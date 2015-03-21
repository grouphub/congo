require 'rails_helper'

RSpec::Matchers.define :be_a_uuid do
  match do |actual|
    actual.match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/)
  end
end

RSpec::Matchers.define :be_a_thirty_six do
  match do |actual|
    actual.match(/[0-9a-z]{22,25}/)
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

