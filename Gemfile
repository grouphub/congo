source 'https://rubygems.org'

gem 'rails', '~> 4.2'

gem 'pg'
gem 'sprockets-rails', :require => 'sprockets/railtie'

gem 'redis-namespace'

gem 'sass-rails'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'

gem 'bcrypt', '~> 3.1.7'

gem 'paranoia', '~> 2.0'

# For running the server.
gem 'shoryuken', '~> 2.0', '>= 2.0.2'
gem 'foreman'
gem 'puma'

# For the payment system.
gem 'stripe'

# For colorizing console output in specs.
gem 'colorize'

# For health insurance enrollment and other concerns.
gem 'pokitdok-ruby', '~> 0.7.2'

# For monitoring.
gem 'newrelic_rpm'

# Protect internal endpoints from the world.
gem 'ng-rails-csrf'

# Throttle external endpoints.
gem 'rack-defense'

# For Amazon S3 attachments
#gem 'aws-s3', github: 'bartoszkopinski/aws-s3'
gem 'aws-s3', '~> 0.6.3'
gem 'fakes3'
gem 'aws-sdk', '~> 2'

# For rich text in groups and benefit plans
gem 'kramdown'

# For worker deployment
gem 'net-ssh-simple'
gem 'ruby-progressbar'
gem 'unindent'

# Papertrail Logging
gem 'remote_syslog_logger'
gem 'airbrake'

group :doc do
  gem 'sdoc', '~> 0.4.0'
end


group :development do
  #for erd generation
  gem "rails-erd"
  # To speed up booting.
  gem 'spring'

  # When an email gets sent in development, it opens in a new window.
  gem 'letter_opener'

  # When loading a page, do not show all the assets loaded in the logs.
  gem 'quiet_assets'

  # For front-end live reloading.
  gem 'guard-livereload', group: :development
  gem 'rack-livereload', group: :development

  # For model diagrams.
  gem 'railroady'
end

# Testing gems.
group :development, :test do
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'factory_girl_rails'

  # For debugging.
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-nav'
  gem 'pry-rails'

  gem 'spring-commands-rspec'
  gem 'faker'
end

group :production do
  gem 'rails_12factor'
end

# ruby ENV['CUSTOM_RUBY_VERSION'] || '2.2.0'
