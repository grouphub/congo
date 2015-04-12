class Notification < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :account
  belongs_to :role

  def subject=(s)
    self.subject_kind = s.class.table_name
    self.subject_id = s.id
  end

  def subject
    self.subject_kind.classify.constantize.find(self.subject_id)
  end

  def mark_as_read
    self.read_at = Time.now
  end
end
