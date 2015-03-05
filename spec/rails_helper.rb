ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'capybara/rails'
require 'capybara/rspec'
# Add additional requires below this line. Rails is not loaded until this point!

ActiveRecord::Migration.maintain_test_schema!

def save_screenshot!
  screenshots_path = "#{Rails.root}/tmp/screenshots"
  screenshot_path = "#{screenshots_path}/#{Time.now.strftime('%Y-%m-%dT%l-%M-%S')}.png"

  FileUtils.mkdir_p(screenshots_path)

  page.save_screenshot(screenshot_path, full: true)

  `open "#{screenshot_path}"`

  sleep 1

  FileUtils.rm(screenshot_path)

  nil
end

RSpec.configure do |config|
  Capybara.javascript_driver = :selenium

  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation, { pre_count: true }
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

