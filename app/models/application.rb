class Application < ActiveRecord::Base
  include Propertied

  belongs_to :account
  belongs_to :benefit_plan
  belongs_to :membership

  has_many :attempts

  # TODO: Finish erroring
  def state
    if self.errored_by_id
      'errored'
    elsif self.submitted_by_id
      'submitted'
    elsif self.approved_by_id
      'approved'
    elsif self.applied_by_id
      'applied'
    elsif self.declined_by_id
      'declined'
    elsif self.selected_by_id
      'selected'
    else
      'not_applied'
    end
  end

  def state_label
    case self.state
    when 'errored'
      'danger'
    when 'submitted'
      'success'
    when 'approved'
      'info'
    when 'applied'
      'info'
    when 'declined'
      'danger'
    when 'selected'
      'warning'
    else
      'default'
    end
  end
end
