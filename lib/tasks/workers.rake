namespace :workers do
  def stop_worker(worker)
    puts %[Stopping the existing worker...]
    worker.ssh! %[
      cd #{worker.to_directory} &&
        [ -a #{worker.pid_file} ] &&
        [ $(cat #{worker.pid_file}) -gt 0 ] &&
        cat #{worker.pid_file} &&
        #{worker.ruby_env} &&
        #{worker.kill_command} &&
        rm #{worker.pid_file}
    ]
  end

  def start_worker(worker)
    puts %[Starting the new worker...]
    worker.ssh! %[
      cd #{worker.to_directory} &&
        #{worker.ruby_env} &&
        touch #{worker.pid_file}
        #{worker.run_command}
    ]
  end

  def default_deploy(worker, zip_path)
    puts %[Deploying to "#{worker.name} at "#{worker.ssh_host}"...]

    puts %[Creating the directory where the project will live...]
    worker.ssh! %[mkdir -p #{worker.to_directory}]

    puts %[Copying the zipped up project to the server...]
    worker.scp! zip_path, worker.to_directory

    puts %[Unzipping the project and removing the zip file...]
    worker.ssh! %[
      cd #{worker.to_directory} &&
        unzip #{worker.workers.timestamp}.zip >/dev/null &&
        rm #{worker.workers.timestamp}.zip
    ]

    puts %[Bundling the project...]
    worker.ssh! %[
      cd #{worker.to_directory} &&
        #{worker.ruby_env} &&
        bundle
    ]

    current_workers = Workers.new('current')
    current_worker = worker.dup
    current_worker.workers = current_workers
    stop_worker(current_worker)

    puts %[Removing the current "current" symlink and link it to the new project...]
    worker.ssh! %[
      rm -f #{worker.deploy_directory}/current &&
        ln -s #{worker.to_directory} #{worker.deploy_directory}/current
    ]

    start_worker(worker)

    puts %[Remove all but the current and last versions of the app...]
    worker.ssh! %[
      cd #{worker.deploy_directory} &&
        ls | sort -r | tail -n +4 | xargs rm -r
    ]

    puts %[Finished deploying to "#{worker.name}".]
    print "\n"
  end

  def run_on_box_or_boxes(with_zip = false, &block)
    name = ENV['WORKER_NAME']
    environment = ENV['WORKER_ENVIRONMENT']
    workers = Workers.new(with_zip ? nil : 'current')

    puts %[Preparing to run task on boxes...]

    workers.with_zip!(with_zip) do |zip_path|
      workers.select_boxes(name, environment).each do |ec2_config|
        Net::SSH::Simple.sync do |s|
          worker = Workers::Worker.new(workers, ec2_config, s)
          puts %[Preparing to run task on box named "#{worker.name}" at "#{worker.ssh_host}"...]
          block.call(worker, zip_path)
        end
      end
    end
  end

  def toggle_maintenance!(to_enable)
    environment = ENV['WORKER_ENVIRONMENT']

    raise 'WORKER_ENVIRONMENT must be specified.' unless environment

    workers = Workers.new('current')

    # Get the first box you can find for the environment.
    box = workers.boxes.find { |ec2_config|
      ec2_config[:environment] == environment
    }

    Net::SSH::Simple.sync do |s|
      worker = Workers::Worker.new(workers, ec2_config, s)

      if to_enable
        puts %[Preparing to put environment "#{environment}" into maintenance mode ] +
          %[from "#{worker.name}" at "#{worker.ssh_host}"...]

        worker.ssh! %[
          cd #{worker.deploy_directory}/current
          bundle exec rake maintenance:start
        ]
      else
        puts %[Preparing to take environment "#{environment}" out of maintenance mode ] +
          %[from "#{worker.name}" at "#{worker.ssh_host}"...]

        worker.ssh! %[
          cd #{worker.deploy_directory}/current
          bundle exec rake maintenance:stop
        ]
      end
    end
  end

  desc 'Deploy application to all boxes or a specific box'
  task :deploy => :environment do
    name = ENV['WORKER_NAME']
    environment = ENV['WORKER_ENVIRONMENT']
    workers = Workers.new

    puts %[Preparing to deploy to boxes...]

    run_on_box_or_boxes(true) do |worker, zip_path|
      default_deploy(worker, zip_path)
    end
  end

  desc 'Stop all workers or a specific worker'
  task :stop => :environment do
    run_on_box_or_boxes do |worker|
      stop_worker(worker)
    end
  end

  desc 'Stop then start all workers or a specific worker'
  task :start => [:stop] do
    run_on_box_or_boxes do |worker|
      start_worker(worker)
    end
  end

  desc 'Stop then start all workers or a specific worker'
  task :restart => [:start]

  desc 'Get info about all worker boxes'
  task :info => :environment do
    pp Workers.new('current').config
  end

  desc 'Ping the boxes'
  task :ping => :environment do
    run_on_box_or_boxes do |worker|
      puts %[Pinging "#{worker.name} at "#{worker.ssh_host}"...]
      worker.ssh! %[echo 'PONG']
    end
  end

  desc 'Check if process is running'
  task :check => :environment do
    run_on_box_or_boxes do |worker|
      puts %[Checking if process is running on "#{worker.name} at "#{worker.ssh_host}"...]
      worker.ssh! %[
        cd #{worker.deploy_directory}/current
        cat #{worker.pid_file}
        if ps -p `cat #{worker.pid_file}` >/dev/null; then
          echo 'RUNNING'
        else
          echo 'NOT RUNNING'
        fi
      ]
    end
  end

  desc 'Check if process is running'
  task :health => [:check]

  # TODO: Are there other logs that should be cleared? Other files?
  desc 'Clear logs'
  task :clear_logs => :environment do
    run_on_box_or_boxes do |worker|
      puts %[Checking if process is running on "#{worker.name} at "#{worker.ssh_host}"...]
      worker.ssh! %[
        cd #{worker.deploy_directory}/current
        bundle exec rake log:clear
      ]
    end
  end

  desc 'Check remaining disk space'
  task :check_disk => :environment do
    run_on_box_or_boxes do |worker|
      puts %[Checking disk space on "#{worker.name} at "#{worker.ssh_host}"...]
      worker.ssh! %[
        df -h
      ]
    end
  end
end

