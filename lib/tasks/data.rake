namespace :data do
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
end

