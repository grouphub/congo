ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'capybara/rails'
require 'capybara/rspec'
require_relative 'helpers/congo_helper'

ActiveRecord::Migration.maintain_test_schema!

# Basics
RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!
end

# Helpers
RSpec.configure do |config|
  config.include(CongoHelper)
end

# Capybara
RSpec.configure do |config|
  Capybara.javascript_driver = :selenium

  config.before(:each, js: true) do
    page.driver.browser.manage.window.resize_to(1024, 768)
  end
end

# Database Cleaner
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation, { pre_count: true }
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

