namespace :db do
  desc 'Dumps the database to db/APP_NAME.dump'
  task :dump => :environment do
    app = Rails.application.class.parent_name.underscore
    host = ActiveRecord::Base.connection_config[:host]
    db = ActiveRecord::Base.connection_config[:database]
    username = ActiveRecord::Base.connection_config[:username]
    password = ActiveRecord::Base.connection_config[:password]

    options = []
    options << "--host #{host}" if host
    options << "--username #{username}" if username

    path = ENV['DUMP_PATH'] || "#{Rails.root}/db/#{app}.dump"
    cmd = %[pg_dump #{options.join(' ')} --verbose --clean --no-owner --no-acl --format=plain #{db} > "#{path}"]
    cmd = %[PGPASSWORD="#{password}" #{cmd}] if password

    puts cmd
    exec cmd
  end

  desc 'Restores the database dump at db/APP_NAME.dump.'
  task :restore => :environment do
    app = Rails.application.class.parent_name.underscore
    host = ActiveRecord::Base.connection_config[:host]
    db = ActiveRecord::Base.connection_config[:database]
    username = ActiveRecord::Base.connection_config[:username]
    password = ActiveRecord::Base.connection_config[:password]

    options = []
    options << "--host #{host}" if host
    options << "--username #{username}" if username

    path = ENV['DUMP_PATH'] || "#{Rails.root}/db/#{app}.dump"
    cmd = %[psql #{options.join(' ')} --file="#{path}" --dbname=#{db}]
    cmd = %[PGPASSWORD="#{password}" #{cmd}] if password

    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke

    puts cmd
    exec cmd
  end
end

