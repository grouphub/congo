require 'bcrypt'
require "#{Rails.root}/lib/sluggerizer"

class User < ActiveRecord::Base
  include Propertied

  has_many :roles
  has_many :applications

  def password
    @password = BCrypt::Password.new(self.encrypted_password)
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.encrypted_password = @password
  end

  def admin?
    User.first.roles.any? { |role| role.name == 'admin' }
  end
end

