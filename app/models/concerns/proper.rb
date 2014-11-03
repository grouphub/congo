module Proper
  extend ActiveSupport::Concern

  def properties=(hash)
    self.properties_data = hash.to_json
  end

  def properties
    JSON.load(self.properties_data)
  end
end

