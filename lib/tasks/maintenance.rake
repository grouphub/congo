namespace :maintenance do
  desc 'Put page in maintenance mode'
  task :start => :environment do
    Maintenance.start
  end

  desc 'Take page out of maintenance mode'
  task :stop => :environment do
    Maintenance.stop
  end
end

