namespace :workers do
  stop_worker = lambda { |worker|
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
  }

  start_worker = lambda { |worker|
    puts %[Starting the new existing worker...]
    worker.ssh! %[
      cd #{worker.to_directory} &&
        #{worker.ruby_env} &&
        touch #{worker.pid_file}
        #{worker.run_command}
    ]
  }

  default_deploy = lambda { |worker, zip_path|
    puts %[Deploying to "#{worker.name} at "#{worker.ssh_host}"...]

    puts %[Creating the directory where the project will live...]
    worker.ssh! %[mkdir -p #{worker.to_directory}]

    puts %[Copying the zipped up project to the server...]
    worker.scp! zip_path, worker.to_directory

    puts %[Unzipping the project and removing the zip file...]
    worker.ssh! %[
      cd #{worker.to_directory} &&
        unzip #{worker.workers.timestamp} >/dev/null &&
        rm #{worker.workers.timestamp}.zip
    ]

    puts %[Bundling the project...]
    worker.ssh! %[
      cd #{worker.to_directory} &&
        #{worker.ruby_env} &&
        bundle
    ]

    stop_worker.call(worker)
    start_worker.call(worker)

    puts %[Removing the current "current" symlink and link it to the new project...]
    worker.ssh! %[
      rm -f #{worker.deploy_directory}/current &&
        ln -s #{worker.to_directory} #{worker.deploy_directory}/current
    ]

    puts %[Remove all but the current and last versions of the app...]
    worker.ssh! %[
      cd #{worker.deploy_directory} &&
        ls | sort -r | tail -n +4 | xargs rm -r
    ]
  }

  task :deploy => :environment do
    name = ENV['WORKER_NAME']
    workers = Workers.new

    if name
      puts %[Preparing to deploy to box named "#{name}"...]

      workers.with_zip! do |zip_path|
        Net::SSH::Simple.sync do |s|
          ec2_config = workers.boxes.find { |ec2_config|
            ec2_config[:name] == name
          }

          raise %[Could not find box with name "#{name}"] unless ec2_config

          worker = Workers::Worker.new(workers, ec2_config, s)
          default_deploy.call(worker, zip_path)
        end
      end
    else
      puts %[Preparing to deploy to all boxes...]

      workers.with_zip! do |zip_path|
        workers.boxes.each do |ec2_config|
          Net::SSH::Simple.sync do |s|
            worker = Workers::Worker.new(workers, ec2_config, s)
            default_deploy.call(worker, zip_path)
          end
        end
      end
    end
  end

  run_on_box_or_boxes = lambda { |callback|
    name = ENV['WORKER_NAME']
    workers = Workers.new('current')

    if name
      puts %[Preparing to run task on box named "#{name}"...]

      Net::SSH::Simple.sync do |s|
        ec2_config = workers.boxes.find { |ec2_config|
          ec2_config[:name] == name
        }

        raise %[Could not find box with name "#{name}"] unless ec2_config

        worker = Workers::Worker.new(workers, ec2_config, s)
        callback.call(worker)
      end
    else
      puts %[Preparing to run task on all boxes...]

      workers.boxes.each do |ec2_config|
        Net::SSH::Simple.sync do |s|
          worker = Workers::Worker.new(workers, ec2_config, s)
          callback.call(worker)
        end
      end
    end
  }

  task :stop => :environment do
    run_on_box_or_boxes.call(lambda { |worker|
      stop_worker.call(worker)
    })
  end

  task :restart => [:stop] do
    run_on_box_or_boxes.call(lambda { |worker|
      stop_worker.call(worker)
    })
  end

  task :start => [:restart]

  task :log => :environment do
    name = ENV['WORKER_NAME']

    raise %[WORKER_NAME environment variable must be set.] unless name

    workers = Workers.new

    Net::SSH::Simple.sync do |s|
      ec2_config = workers.boxes.find { |ec2_config|
        ec2_config[:name] == name
      }

      raise %[Could not find box with name "#{name}"] unless ec2_config

      worker = Workers::Worker.new(workers, ec2_config, s)

      puts %[Tailng log for "#{name}"...]
      worker.ssh! %[
        tail -f #{worker.deploy_directory}/current/#{worker.log_file}
      ]
    end
  end
end

