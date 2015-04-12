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

    # TODO: Validation

    # Step 1: Load in data and store association ids in a hash
    associations = {}

    account = Account.with_deleted.where(slug: data['account']['slug']).first
    if account
      puts 'An account with this slug already exists. Nuking it.'
      account.eviscerate!
    end

    attributes = data['account'].reject { |k, v| k == 'id' }

    # Step 1: Create the account.
    account = Account.create!(attributes)

    associations['account_id'] = {}
    associations['account_id'][data['account']['id']] = account.id

    # Step 2: Populate attributes and create indices from old ids to new ids.
    data.except('account', 'users').each do |table_name, rows|
      rows.each do |row|
        item = table_name.classify.constantize.create! \
          row.reject { |k, v|
            k == 'id'
          }

        associations["#{table_name.singularize}_id"] ||= {}
        associations["#{table_name.singularize}_id"][row['id']] = item.id
      end
    end

    # Step 3: Replace old ids with new ids.
    data.except('account', 'users').each do |table_name, rows|
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
            pp name_id, associations[name_id]
            item.update_attribute(name_id, associations[name_id][v])
          end
        end
      end
    end

    # Step 4: Populate the user ids.
    %w[memberships roles].each do |table_name|
      rows = data[table_name]

      rows.each do |row|
        item_id = associations["#{table_name.singularize}_id"][row['id']]
        item = table_name.classify.constantize.find(item_id)

        user_email = data['users'][row['user_id'].to_s]
        user = User.where(email: user_email).first

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

    data['account'] = account.as_json

    data['users'] = {}

    KEYS.each do |key|
      data[key] = account.instance_eval(key).as_json
    end

    data['memberships'].each do |membership|
      user = User.find(membership['user_id'])

      data['users'][membership['user_id']] = user.email
    end

    data['roles'].each do |role|
      user = User.find(role['user_id'])

      data['users'][role['user_id']] = user.email
    end

    File.open(path, 'w') do |f|
      f.puts(JSON.pretty_generate(data))
    end
  end
end

