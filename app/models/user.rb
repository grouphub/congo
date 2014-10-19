require 'bcrypt'
require "#{Rails.root}/lib/sluggerizer"

class User < ActiveRecord::Base
  has_many :account_users

  def roles=(list)
    self.roles_data = list
      .map { |item| Sluggerizer::sluggerize(item) }
      .join(', ')
  end

  def roles
    self.roles_data.split(', ')
  end

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

  def accounts
    self
      .account_users
      .includes(:account)
      .inject([]) { |sum, account_user|
        sum << account_user.account
        sum
      }
  end

  def simple_hash
    {
      id: self.id,
      first_name: self.first_name,
      last_name: self.last_name,
      email: self.email,
      accounts: self.accounts.map { |account| account.simple_hash }
    }
  end
end

