require 'bcrypt'
require "#{Rails.root}/lib/sluggerizer"

class User < ActiveRecord::Base
  include Propertied

  acts_as_paranoid

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

  def nuke!
    roles = Role.where(user_id: self.id)
    memberships = Membership.where(user_id: self.id)
    applications = Application.where('membership_id IN (?)', memberships.map(&:id))
    application_statuses = ApplicationStatus.where('application_id IN (?)', applications.map(&:id))

    application_statuses.destroy_all
    applications.destroy_all
    memberships.destroy_all
    roles.destroy_all

    self.destroy!
  end

  def eviscerate!
    roles = Role.where(user_id: self.id)
    memberships = Membership.where(user_id: self.id)
    applications = Application.where('membership_id IN (?)', memberships.map(&:id))
    application_statuses = ApplicationStatus.where('application_id IN (?)', applications.map(&:id))

    application_statuses.each(:really_destroy!)
    applications.each(:really_destroy!)
    memberships.each(:really_destroy!)
    roles.each(:really_destroy!)

    self.really_destroy!
  end
end

