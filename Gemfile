source 'https://rubygems.org'

gem 'rails', github: 'rails/rails', branch: '4-1-stable'

gem 'pg'
gem 'sprockets-rails', github: 'rails/sprockets-rails', branch: '2.x'

gem 'sass-rails', github: 'rails/sass-rails'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', github: 'rails/coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'puma'

gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'

gem 'bcrypt', '~> 3.1.7'

gem 'pry'
gem 'foreman'
gem 'guard-livereload', group: :development
gem 'rack-livereload', group: :development

gem 'clockwork'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'stripe'

gem 'pokitdok-ruby', github: 'pokitdok/pokitdok-ruby'

gem 'newrelic_rpm'

# Protect internal endpoints from the world.
gem 'ng-rails-csrf'

# Throttle external endpoints.
gem 'rack-defense'

group :doc do
  gem 'sdoc', '~> 0.4.0'
end

group :development do
  gem 'spring'
  gem 'letter_opener'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :production do
  gem 'rails_12factor'
end

ruby '2.1.5'

