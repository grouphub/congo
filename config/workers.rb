{
  boxes: [
    # Demo Worker Box 1
    {
      name: 'congo-demo-worker-1',
      environment: 'congo-demo',
      ssh_host: 'ec2-52-6-162-53.compute-1.amazonaws.com',
      ssh_args: {
        user: 'ec2-user',
        keys_only: true,
        keys: [
          "#{ENV['HOME']}/.ssh/grouphub-congo"
        ],
        timeout: 0,
        operation_timeout: 0
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

    # Demo Clock Box 1
    {
      name: 'congo-demo-clock-1',
      environment: 'congo-demo',
      ssh_host: 'ec2-52-5-105-244.compute-1.amazonaws.com',
      ssh_args: {
        user: 'ec2-user',
        keys_only: true,
        keys: [
          "#{ENV['HOME']}/.ssh/grouphub-congo"
        ],
        timeout: 0,
        operation_timeout: 0
      },
      deploy_directory: '/home/ec2-user/congo',
      pid_file: 'tmp/pids/clock.pid',
      log_file: 'log/clock.log',
      kill_command: 'kill -KILL $(cat tmp/pids/clock.pid)',
      run_command: 'script/clock_daemon'
    },

    # Test Worker Box 1
    {
      name: 'congo-test-worker-1',
      environment: 'congo-test',
      ssh_host: 'ec2-52-7-65-24.compute-1.amazonaws.com',
      ssh_args: {
        user: 'ec2-user',
        keys_only: true,
        keys: [
          "#{ENV['HOME']}/.ssh/grouphub-congo"
        ],
        timeout: 0,
        operation_timeout: 0
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

    # Test Clock Box 1
    {
      name: 'congo-test-clock-1',
      environment: 'congo-test',
      ssh_host: 'ec2-52-0-233-227.compute-1.amazonaws.com',
      ssh_args: {
        user: 'ec2-user',
        keys_only: true,
        keys: [
          "#{ENV['HOME']}/.ssh/grouphub-congo"
        ],
        timeout: 0,
        operation_timeout: 0
      },
      deploy_directory: '/home/ec2-user/congo',
      pid_file: 'tmp/pids/clock.pid',
      log_file: 'log/clock.log',
      kill_command: 'kill -KILL $(cat tmp/pids/clock.pid)',
      run_command: 'script/clock_daemon'
    },

    # Integration Worker Box 1
    {
      name: 'congo-integration-worker-1',
      environment: 'congo-integration',
      ssh_host: 'ec2-52-3-242-237.compute-1.amazonaws.com',
      ssh_args: {
        user: 'ec2-user',
        keys_only: true,
        keys: [
          "#{ENV['HOME']}/.ssh/id_rsa"
        ],
        timeout: 0,
        operation_timeout: 0
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

    # Integration Clock Box 1
    {
      name: 'congo-integration-clock-1',
      environment: 'congo-integration',
      ssh_host: 'ec2-52-91-88-35.compute-1.amazonaws.com',
      ssh_args: {
        user: 'ec2-user',
        keys_only: true,
        keys: [
          "#{ENV['HOME']}/.ssh/id_rsa"
        ],
        timeout: 0,
        operation_timeout: 0
      },
      deploy_directory: '/home/ec2-user/congo',
      pid_file: 'tmp/pids/clock.pid',
      log_file: 'log/clock.log',
      kill_command: 'kill -KILL $(cat tmp/pids/clock.pid)',
      run_command: 'script/clock_daemon'
    },

    # Staging Worker Box 1
    {
      name: 'congo-staging-worker-1',
      environment: 'congo-staging',
      ssh_host: 'ec2-52-6-56-79.compute-1.amazonaws.com',
      ssh_args: {
        user: 'ec2-user',
        keys_only: true,
        keys: [
          "#{ENV['HOME']}/.ssh/grouphub-congo"
        ],
        timeout: 0,
        operation_timeout: 0
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

    # Staging Clock Box 1
    {
      name: 'congo-staging-clock-1',
      environment: 'congo-staging',
      ssh_host: 'ec2-52-4-211-151.compute-1.amazonaws.com',
      ssh_args: {
        user: 'ec2-user',
        keys_only: true,
        keys: [
          "#{ENV['HOME']}/.ssh/grouphub-congo"
        ],
        timeout: 0,
        operation_timeout: 0
      },
      deploy_directory: '/home/ec2-user/congo',
      pid_file: 'tmp/pids/clock.pid',
      log_file: 'log/clock.log',
      kill_command: 'kill -KILL $(cat tmp/pids/clock.pid)',
      run_command: 'script/clock_daemon'
    },

    # Production Worker Box 1
    {
      name: 'congo-production-worker-1',
      environment: 'congo-production',
      ssh_host: 'ec2-52-5-153-195.compute-1.amazonaws.com',
      ssh_args: {
        user: 'ec2-user',
        keys_only: true,
        keys: [
          "#{ENV['HOME']}/.ssh/grouphub-congo"
        ],
        timeout: 0,
        operation_timeout: 0
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

    # Production Clock Box 1
    {
      name: 'congo-production-clock-1',
      environment: 'congo-production',
      ssh_host: 'ec2-52-0-141-43.compute-1.amazonaws.com',
      ssh_args: {
        user: 'ec2-user',
        keys_only: true,
        keys: [
          "#{ENV['HOME']}/.ssh/grouphub-congo"
        ],
        timeout: 0,
        operation_timeout: 0
      },
      deploy_directory: '/home/ec2-user/congo',
      pid_file: 'tmp/pids/clock.pid',
      log_file: 'log/clock.log',
      kill_command: 'kill -KILL $(cat tmp/pids/clock.pid)',
      run_command: 'script/clock_daemon'
    }
  ]
}

