namespace :db do
  desc 'Dumps the database to db/APP_NAME.dump'
  task :dump => :environment do
    app = Rails.application.class.parent_name.underscore
    host = ActiveRecord::Base.connection_config[:host]
    db = ActiveRecord::Base.connection_config[:database]
    username = ActiveRecord::Base.connection_config[:username]

    options = []
    options << "--host #{host}" if host
    options << "--username #{username}" if username

    pp app

    path = ENV['DUMP_PATH'] || "#{Rails.root}/db/#{app}.dump"
    cmd = %[pg_dump #{options.join('')} --verbose --clean --no-owner --no-acl --format=c #{db} > "#{path}"]

    puts cmd
    exec cmd
  end

  desc 'Restores the database dump at db/APP_NAME.dump.'
  task :restore => :environment do
    app = Rails.application.class.parent_name.underscore
    host = ActiveRecord::Base.connection_config[:host]
    db = ActiveRecord::Base.connection_config[:database]
    username = ActiveRecord::Base.connection_config[:username]

    options = []
    options << "--host #{host}" if host
    options << "--username #{username}" if username

    path = ENV['DUMP_PATH'] || "#{Rails.root}/db/#{app}.dump"
    cmd = %[pg_restore --verbose #{options.join('')} --clean --no-owner --no-acl --dbname #{db} "#{path}"]

    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke

    puts cmd
    exec cmd
  end
end

