require 'bcrypt'

class User < ActiveRecord::Base
  def roles=(list)
    self.roles_data = list.map { |item| sluggerize item }.join(', ')
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

  def simple_hash
    {
      name: self.name,
      email: self.email
    }
  end

  def sluggerize(string)
    str = string.downcase.gsub(/[^\w]/, "_").gsub(/__+/, "_")
    str = str[1..-1] while str[0] == "_"
    str = str[0..-2] while str[-1] == "_"
    str
  end
end

