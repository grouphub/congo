require 'bcrypt'
require "#{Rails.root}/lib/sluggerizer"

class User < ActiveRecord::Base
  has_many :account_users

  def properties=(hash)
    self.properties_data = hash.to_json
  end

  def properties
    JSON.load(self.properties_data)
  end

  def password
    @password = BCrypt::Password.new(self.encrypted_password)
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.encrypted_password = @password
  end

  def simple_hash
    accounts = self
      .account_users
      .includes(:account)
      .inject([]) { |sum, account_user|
        account_hash = account_user.account.try(:as_json)

        if account_hash
          account_hash['role'] = account_user.role
        end

        sum << account_hash
        sum
      }

    {
      id: self.id,
      first_name: self.first_name,
      last_name: self.last_name,
      email: self.email,
      accounts: accounts
    }
  end
end

