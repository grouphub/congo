namespace :frontends do
  namespace :maintenance do
    desc 'Put page in maintenance mode'
    task :start => :environment do
      environment = ENV['FRONTEND_ENVIRONMENT']

      raise 'FRONTEND_ENVIRONMENT must be provided.' unless environment

      sh "eb setenv MAINTENANCE=true -e #{environment}"
    end

    desc 'Take page out of maintenance mode'
    task :stop => :environment do
      environment = ENV['FRONTEND_ENVIRONMENT']

      raise 'FRONTEND_ENVIRONMENT must be provided.' unless environment

      sh "eb setenv MAINTENANCE=false -e #{environment}"
    end
  end

  # TODO: Use user-facing URLs instead. Will require adding a config file.
  desc 'Check the health of an endpoint'
  task :health => :environment do
    environment = ENV['FRONTEND_ENVIRONMENT']

    raise 'FRONTEND_ENVIRONMENT must be provided.' unless environment

    endpoint = "http://#{environment}.elasticbeanstalk.com/api/internal/health"

    sh %[
      [[ $(curl -s -o /dev/null -w "%{http_code}" "#{endpoint}") -eq '200' ]] &&
        echo 'OK' ||
        echo 'ERROR'
    ]
  end
end

