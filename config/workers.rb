{
  boxes: [
    # Worker box
    {
      name: 'congo-staging-worker-1',
      ssh_host: 'ec2-52-1-31-195.compute-1.amazonaws.com',
      ssh_args: {
        user: 'ec2-user',
        keys_only: true,
        keys: [
          "#{ENV['HOME']}/.ssh/grouphub-congo"
        ]
      },
      deploy_directory: '/home/ec2-user/congo',
      pid_file: 'tmp/pids/shoryuken.pid',
      log_file: 'log/shoryuken.log',
      kill_command: 'kill -KILL $(cat tmp/pids/shoryuken.pid)',
      run_command: 'bundle exec shoryuken ' +
        '--pidfile=tmp/pids/shoryuken.pid ' +
        '--logfile=log/shoryuken.log ' +
        '--config=config/shoryuken.yml ' +
        '--rails ' +
        '--daemon'
    },

    # Clock box
    {
      name: 'congo-staging-clock-1',
      ssh_host: 'ec2-52-4-211-151.compute-1.amazonaws.com',
      ssh_args: {
        user: 'ec2-user',
        keys_only: true,
        keys: [
          "#{ENV['HOME']}/.ssh/grouphub-congo"
        ]
      },
      deploy_directory: '/home/ec2-user/congo',
      pid_file: 'tmp/pids/clock.pid',
      log_file: 'log/clock.log',
      kill_command: 'kill -KILL $(cat tmp/pids/clock.pid)',
      run_command: 'script/clock_daemon'
    }
  ]
}

