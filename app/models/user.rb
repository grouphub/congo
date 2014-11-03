require 'bcrypt'
require "#{Rails.root}/lib/sluggerizer"

class User < ActiveRecord::Base
  include Proper

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

  def simple_hash
    accounts = self
      .roles
      .includes(:account)
      .inject([]) { |sum, role|
        account_hash = role.account.try(:as_json)

        if account_hash
          account_hash['role'] = role
        end

        sum << account_hash
        sum
      }

    {
      id: self.id,
      first_name: self.first_name,
      last_name: self.last_name,
      email: self.email,
      accounts: accounts,
      is_admin: admin?
    }
  end
end

