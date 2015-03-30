# TODO: Set envs
# TODO: Test out killing and running

namespace :workers do
  task :deploy => :environment do
    config = eval(File.read("#{Rails.root}/config/workers.rb"))

    timestamp = Time.now.to_i
    zip_file = "../#{timestamp}.zip"

    puts %[Zipping up the app to "#{zip_file}"]
    `zip -r #{zip_file} * .[^.]*`

    config[:boxes].each do |ec2_config|
      Net::SSH::Simple.sync do
        name = ec2_config[:name]
        ssh_host = ec2_config[:ssh_host]
        ssh_args = ec2_config[:ssh_args]
        deploy_directory = ec2_config[:deploy_directory]
        pid_file = ec2_config[:pid_file]
        kill_command = ec2_config[:kill_command]
        run_command = ec2_config[:run_command]
        user = ssh_args[:user]

        ruby_env = '. ~/.bashrc'
        to_directory = %[#{deploy_directory}/#{timestamp}]
        to_basefile = %[#{timestamp}.zip]
        to_file = %[#{to_directory}/#{to_basefile}]

        puts %[Connected to "#{name} at "#{ssh_host}"...]

        # Create the directory where the project will live.
        command = %[mkdir -p #{deploy_directory}/#{timestamp}]
        puts %[Executing `#{command}`...]
        result = ssh ssh_host, command, ssh_args
        puts 'Box returned result:'
        puts result.stdout.colorize(:blue)
        puts result.stderr.colorize(:yellow)

        # Copy the zipped up project to the server
        progress_bar = ProgressBar.create(autofinish: false)
        puts %[Copying "#{zip_file}" to "#{to_directory}"]
        scp_put ssh_host, zip_file, to_directory, ssh_args do |sent, total|
          progress_bar.total = total
          progress_bar.progress = sent
        end
        progress_bar.finish

        # Unzip the project and remove the zip file.
        command = %[cd #{to_directory} && unzip #{to_basefile} && rm #{to_basefile}]
        puts %[Executing `#{command}`...]
        result = ssh ssh_host, command, ssh_args
        puts 'Box returned result:'
        puts result.stdout.colorize(:blue)
        puts result.stderr.colorize(:yellow)

        # Bundle the project.
        command = %[cd #{to_directory} && #{ruby_env} && bundle]
        puts %[Executing `#{command}`...]
        result = ssh ssh_host, command, ssh_args
        puts 'Box returned result:'
        puts result.stdout.colorize(:blue)
        puts result.stderr.colorize(:yellow)

        # Kill the existing worker.
        command = %[cd #{to_directory} && #{ruby_env} && #{kill_command} && rm #{pid_file}]
        puts %[Executing `#{command}`...]
        result = ssh ssh_host, command, ssh_args
        puts 'Box returned result:'
        puts result.stdout.colorize(:blue)
        puts result.stderr.colorize(:yellow)

        # Start the new existing worker.
        command = %[cd #{to_directory} && #{ruby_env} && #{run_command}]
        puts %[Executing `#{command}`...]
        result = ssh ssh_host, command, ssh_args
        puts 'Box returned result:'
        puts result.stdout.colorize(:blue)
        puts result.stderr.colorize(:yellow)

        # Remove the current "current" symlink and link it to the new project
        command = %[rm -f #{deploy_directory}/current && ] +
          %[ln -s #{deploy_directory}/#{timestamp} #{deploy_directory}/current]
        puts %[Executing `#{command}`...]
        ssh ssh_host, command, ssh_args
      end
    end

    `rm #{zip_file}`
  end
end

