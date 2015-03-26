require 'bcrypt'
require "#{Rails.root}/lib/sluggerizer"

class User < ActiveRecord::Base
  include Propertied

  has_many :roles
  has_many :memberships

  validates_uniqueness_of :email

  def password
    @password = BCrypt::Password.new(self.encrypted_password)
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.encrypted_password = @password
  end

  def full_name
    [self.first_name, self.last_name].join(' ').strip
  end

  def admin?
    self.roles.any? { |role| role.name == 'admin' }
  end
end

