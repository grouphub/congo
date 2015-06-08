source 'https://rubygems.org'

gem 'rails', github: 'rails/rails', branch: '4-2-stable'

gem 'pg'
gem 'sprockets-rails', github: 'rails/sprockets-rails', branch: '2.x'

gem 'redis-namespace'

gem 'sass-rails', github: 'rails/sass-rails'

gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', github: 'rails/coffee-rails'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'

gem 'bcrypt', '~> 3.1.7'

gem 'paranoia', '~> 2.0'

# For running the server.
gem 'shoryuken'
gem 'foreman'
gem 'puma'

# For background worker processes.
gem 'redlock'

# For the payment system.
gem 'stripe'

# For colorizing console output in specs.
gem 'colorize'

# For health insurance enrollment and other concerns.
gem 'pokitdok-ruby', github: 'pokitdok/pokitdok-ruby', require: 'pokitdok'

# For monitoring.
gem 'newrelic_rpm'

# Protect internal endpoints from the world.
gem 'ng-rails-csrf'

# Throttle external endpoints.
gem 'rack-defense'

# For Amazon S3 attachments
gem 'aws-s3', github: 'bartoszkopinski/aws-s3'
gem 'fakes3'

# For rich text in groups and benefit plans
gem 'kramdown'

# For worker deployment
gem 'net-ssh-simple'
gem 'ruby-progressbar'
gem 'unindent'

# Papertrail Logging
gem 'remote_syslog_logger'

# Spreadsheets
gem 'rubyXL'

group :doc do
  gem 'sdoc', '~> 0.4.0'
end

group :development do
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

  # For debugging.
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-nav'
  gem 'pry-rails'
end

ruby ENV['CUSTOM_RUBY_VERSION'] || '2.2.0'

