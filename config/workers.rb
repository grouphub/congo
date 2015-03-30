{
  boxes: [
    {
      name: 'staging-worker-1',
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
      kill_command: 'kill -KILL $(cat tmp/pids/shoryuken.pid)',
      run_command: 'bundle exec shoryuken --pidfile=tmp/pids/shoryuken.pid --logfile=log/shoryuken.log --concurrency=1 --rails --daemon --config=config/shoryuken.yml'
    }
  ]
}

