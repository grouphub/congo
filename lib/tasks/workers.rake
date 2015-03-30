# TODO: Set envs
# TODO: Test out killing and running

class Workers
  attr_reader :config, :timestamp, :zip_file

  def initialize
    @config = eval(File.read("#{Rails.root}/config/workers.rb"))
    @timestamp = Time.now.to_i
    @zip_file = "../#{timestamp}.zip"
  end

  def generate_zip!
    puts %[Zipping up the app to "#{zip_file}"]
    `zip -r #{zip_file} * .[^.]*`
  end

  def remove_zip!
    puts %[Removing the zip file "#{zip_file}"]
    FileUtils.rm(zip_file)
  end

  def with_zip!(&block)
    workers.generate_zip!

    begin
      block.call
    ensure
      workers.remove_zip!
    end
  end

  def boxes
    config[:boxes]
  end

  class Worker
    attr_accessor :workers, :ec2_config, :s

    def initialize(workers, ec2_config, s)
      @ec2_config = ec2_config
      @s = s
    end

    def name
      ec2_config[:name]
    end

    def ssh_host
      ssh_host = ec2_config[:ssh_host]
    end

    def ssh_args
      ssh_args = ec2_config[:ssh_args]
    end

    def deploy_directory
      ec2_config[:deploy_directory]
    end

    def pid_file
      ec2_config[:pid_file]
    end

    def kill_command
      ec2_config[:kill_command]
    end

    def run_command
      ec2_config[:run_command]
    end

    def ruby_env
      '. ~/.bashrc'
    end

    def to_directory
      %[#{worker.deploy_directory}/#{workers.timestamp}]
    end

    def ssh!(command)
      puts %[Executing `#{command}`...]
      result = s.ssh ssh_host, command, ssh_args
      stdout = result.stdout.strip
      stderr = result.stderr.strip

      puts 'Box returned result:' unless stdout.empty? && stderr.empty?
      puts result.stdout.colorize(:blue) unless stdout.empty?
      puts result.stderr.colorize(:yellow) unless stderr.empty?
    end

    def scp!(from, to)
      progress_bar = ProgressBar.create(autofinish: false)
      begin
        puts %[Copying "#{zip_file}" to "#{to_directory}"]
        s.scp_put ssh_host, from, to, ssh_args do |sent, total|
          progress_bar.total = total
          progress_bar.progress = sent
        end
      ensure
        progress_bar.finish
      end
    end
  end
end

namespace :workers do
  default_deploy = lambda { |worker|
    puts %[Deploying to "#{worker.name} at "#{worker.ssh_host}"...]

    # Create the directory where the project will live.
    worker.ssh! %[mkdir -p #{worker.to_directory}]

    # Copy the zipped up project to the server
    worker.scp! workers.zip_file, worker.to_directory

    # Unzip the project and remove the zip file.
    worker.ssh! %[cd #{worker.to_directory} && ] +
      %[unzip #{workers.timestamp} && ] +
      %[rm #{workers.timestamp}]

    # Bundle the project.
    worker.ssh! %[cd #{worker.to_directory} && ] +
      %[#{worker.ruby_env} && ] +
      %[bundle]

    # Kill the existing worker.
    worker.ssh! %[cd #{worker.to_directory} && ] +
      %[#{worker.ruby_env} && ] +
      %[#{worker.kill_command} && ] +
      %[rm #{worker.pid_file}]

    # Start the new existing worker.
    worker.ssh! %[cd #{worker.to_directory} && ] +
      %[#{worker.ruby_env} && ] +
      %[#{worker.run_command}]

    # Remove the current "current" symlink and link it to the new project
    worker.ssh! %[rm -f #{worker.deploy_directory}/current && ] +
      %[ln -s #{worker.to_directory} #{worker.deploy_directory}/current]
  }

  task :deploy => :environment do
    workers = Workers.new

    workers.with_zip! do
      workers.boxes.each do |ec2_config|
        Net::SSH::Simple.sync do |s|
          worker = Workers::Worker.new(workers, ec2_config, s)
          default_deploy.call(worker)
        end
      end
    end
  end

  task :deploy_one, [:name] => :environment do |t, args|
    name = args[:name]
    workers = Workers.new

    workers.with_zip! do
      ec2_config = workers.boxes.find { |ec2_config|
        ec2_config[:name] == name
      }

      raise %[Could not find box with name "#{name}"] unless ec2_config

      worker = Workers::Worker.new(workers, ec2_config, s)
      default_deploy.call(worker)
    end
  end
end

