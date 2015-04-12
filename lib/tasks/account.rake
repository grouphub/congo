# TODO: Test this
namespace :account do
  KEYS = %w[
    account_benefit_plans
    group_benefit_plans
    attachments
    applications
    application_statuses
    benefit_plans
    memberships
    carrier_accounts
    groups
    roles
    tokens
    carriers
    invitations
    notifications
  ]

  desc 'Import an account'
  task :import => :environment do
    account_id = ENV['ACCOUNT_ID'].to_i
    path = ENV['ACCOUNT_PATH'] || "#{Rails.root}/db/#{account_id}.json"
    data = JSON.load(File.read(path))

    raise 'ACCOUNT_ID environment variable must be specified.' unless account_id

    puts 'Step 1: Create the account.'.colorize(:light_blue)

    associations = {}

    attributes = data['account'].reject { |k, v| k == 'id' }

    account = Account.where(slug: data['account']['slug']).first
    if account
      puts 'An account with this slug already exists. Updating it.'
      account.update_attributes!(attributes)
    else
      account = Account.create!(attributes)
    end

    associations['account_id'] ||= {}
    associations['account_id'][data['account']['id']] = account.id

    puts 'Step 2: Create the users.'.colorize(:light_blue)

    data['users'].each do |id, attributes|
      user = User.where(email: attributes['email']).first
      if user
        puts 'A user with this email already exists. Updating it.'
        user.update_attributes!(attributes)
      else
        user = User.create!(attributes)
      end

      associations['user_id'] ||= {}
      associations['user_id'][id] = user.id
    end

    puts 'Step 3: Populate attributes and create indices from old ids to new ids.'.colorize(:light_blue)

    data.except('account', 'users', 'user_emails').each do |table_name, rows|
      rows.each do |row|
        item = table_name.classify.constantize.create! \
          row.reject { |k, v|
            k == 'id'
          }

        associations["#{table_name.singularize}_id"] ||= {}
        associations["#{table_name.singularize}_id"][row['id']] = item.id
      end
    end

    puts 'Step 4: Replace old ids with new ids.'.colorize(:light_blue)

    data.except('account', 'users', 'user_emails').each do |table_name, rows|
      rows.each do |row|
        item_id = associations["#{table_name.singularize}_id"][row['id']]
        item = table_name.classify.constantize.find(item_id)

        row.each do |k, v|
          next if k == 'user_id'
          next if k == 'unique_id' # TODO: Exceptional case

          match = k.match(/(\w+)_id$/)

          if match
            name = match[1].singularize
            name_id = "#{name}_id"

            unless associations[name_id]
              puts %[Attribute #{name_id} on an item #{table_name} with id #{row['id']} was nil. Skipping.]
              next
            end

            item.update_attribute(name_id, associations[name_id][v])
          end
        end
      end
    end

    puts 'Step 5: Populate the user ids.'.colorize(:light_blue)

    %w[memberships roles].each do |table_name|
      rows = data[table_name]

      rows.each do |row|
        item_id = associations["#{table_name.singularize}_id"][row['id']]
        item = table_name.classify.constantize.find(item_id)

        user_email = data['user_emails'][row['user_id'].to_s]
        user = User.where(email: user_email).first

        unless user
          puts %[Could not find a user for email "#{user_email}". Skipping.]
          next
        end

        item.update_attribute(:user_id, user.id)
      end
    end
  end

  desc 'Export an account'
  task :export => :environment do
    account_id = ENV['ACCOUNT_ID'].to_i
    account = Account.find(account_id)
    path = ENV['ACCOUNT_PATH'] || "#{Rails.root}/db/#{account_id}.json"
    data = {}

    raise 'ACCOUNT_ID environment variable must be specified.' unless account_id

    data['account'] = account.as_json

    data['user_emails'] = {}
    data['users'] = {}

    KEYS.each do |key|
      puts "Exporting #{key}.".colorize(:light_blue)
      data[key] = account.instance_eval(key).as_json
    end

    %w[memberships roles].each do |kind|
      puts "Getting a list of users associated with #{kind}.".colorize(:light_blue)
      data[kind].each do |item|
        user = User.where(id: item['user_id']).first

        unless user
          puts %[Could not find a user with id "#{item['user_id'].inspect}". Skipping.]
          next
        end

        data['user_emails'][item['user_id']] = user.email
      end
    end

    puts 'Exporting users.'.colorize(:light_blue)

    data['user_emails'].each do |id, email|
      user = User.where(id: id).first

      unless user
        puts %[Could not find a user with id "#{id}". Skipping.]
        next
      end

      data['users'][id] = user.as_json
    end

    File.open(path, 'w') do |f|
      f.puts(JSON.pretty_generate(data))
    end
  end
end

