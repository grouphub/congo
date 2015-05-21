namespace :data do
  STATES = %w[AL AK AZ AR CA CO CT DE DC FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY]

  namespace :carriers do
    desc 'Fetch carrier data from Pokitdok'
    task :fetch => :environment do
      response = pokitdok.trading_partners

      if response['data'].empty?
        Rails.logger.warn 'Response data was empty. You may not be using production credentials.'
      end

      File.open("#{Rails.root}/spec/data/carrier-response.json", 'w') do |f|
        f.puts JSON.pretty_generate(response)
      end
    end
  end

  namespace :benefit_plans do
    desc 'Fetch benefit plan data from Pokitdok'
    task :fetch => :environment do
      path = "#{Rails.root}/spec/data/benefit_plans"

      FileUtils.rm_rf(path)
      FileUtils.mkdir_p(path)

      STATES.each do |state|
        puts "Fetching benefit plan data for \"#{state}\"..."

        response = pokitdok.plans(state: state)

        if response['data'].empty?
          Rails.logger.warn 'Response data was empty. You may not be using production credentials.'
        end

        File.open("#{path}/#{state.downcase}-response.json", 'w') do |f|
          f.puts JSON.pretty_generate(response)
        end
      end
    end
  end

  desc 'Fetch external data'
  task :fetch => :environment do
    Rake::Task['data:carriers:fetch'].invoke
    Rake::Task['data:benefit_plans:fetch'].invoke
  end
end

