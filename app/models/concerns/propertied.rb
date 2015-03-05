module Propertied
  extend ActiveSupport::Concern

  included do
    before_save :populate_properties
  end

  def populate_properties
    self.properties_data ||= {}.to_json
  end

  def properties=(hash)
    self.properties_data = hash.to_json
  end

  def properties
    JSON.load(self.properties_data)
  end
end

