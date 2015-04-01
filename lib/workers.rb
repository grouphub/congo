# Helper class for managing remote workers and their deployment.
class Workers
  attr_reader :config, :timestamp

  def initialize(timestamp = nil)
    @config = eval(File.read("#{Rails.root}/config/workers.rb"))
    @timestamp = timestamp || Time.now.to_i
  end

  def with_zip!(&block)
    Dir.mktmpdir do |directory|
      zip_path = File.join(directory, "#{timestamp}.zip")

      puts %[Zipping up the app to "#{zip_path}"...]
      `zip -r #{zip_path} * .[^.]*`

      block.call(zip_path)
    end
  end

  def boxes
    config[:boxes]
  end

  class Worker
    attr_accessor :workers, :ec2_config, :s

    def initialize(workers, ec2_config, s)
      @workers = workers
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

    def log_file
      ec2_config[:log_file]
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
      %[#{deploy_directory}/#{workers.timestamp}]
    end

    def ssh!(command)
      cmd = command.unindent.strip

      puts cmd.colorize(:light_blue)
      result = s.ssh ssh_host, cmd, ssh_args
      stdout = result.stdout.chomp
      stderr = result.stderr.chomp

      puts result.stdout.colorize(:green) unless stdout.empty?
      puts result.stderr.colorize(:yellow) unless stderr.empty?
    end

    def scp!(from, to)
      progress_bar = ProgressBar.create(autofinish: false)
      begin
        puts %[Copying "#{from}" to "#{to}"...]
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

