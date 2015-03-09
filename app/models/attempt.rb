class Attempt < ActiveRecord::Base
  include Propertied

  belongs_to :application

  def response=(hash)
    self.response_data = hash.to_json
  end

  def response
    JSON.load(self.response_data)
  end
end

