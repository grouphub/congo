require 'bcrypt'

class User < ActiveRecord::Base
  has_many :account_users

  before_save :add_slug

  def add_slug
    self.slug = Sluggerizer.sluggerize(self.name)
  end

  def roles=(list)
    self.roles_data = list
      .map { |item| Sluggerizer::sluggerize(item) }
      .join(', ')
  end

  def roles
    self.roles_data.split(', ')
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
      name: self.name,
      email: self.email,
      accounts: self.accounts.map { |account| account.simple_hash }
    }
  end
end

