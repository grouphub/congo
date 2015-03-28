class Application < ActiveRecord::Base
  include Propertied

  belongs_to :account
  belongs_to :benefit_plan
  belongs_to :membership

  before_save :populate_reference_number

  def populate_reference_number
    self.reference_number ||= ThirtySix.generate
  end

  def to_pokitdok
    account = self.account
    benefit_plan = self.benefit_plan
    carrier_account = benefit_plan.carrier_account
    carrier = carrier_account.carrier
    membership = self.membership
    group = membership.group
    properties = self.properties
    output_data = {}

    # TODO: Validation
    # TODO: Form validation

    output_data['async'] = true
    output_data['callback_url'] = sprintf \
      '%s/api/internal/accounts/%s/roles/%s/applications/%s/callback.json',
      Rails.application.config.pokitdok.callback_host,
      account.slug,
      membership.role.name,
      application.id

    output_data['action'] = 'Change'

    output_data['payer'] = {}
    output_data['payer']['tax_id'] = carrier.properties['tax_id']

    output_data['purpose'] = 'Original'
    output_data['reference_number'] = self.reference_number
    output_data['trading_partner_id'] = carrier.properties['trading_partner_id']

    output_data['sponsor'] = {}
    output_data['name'] = group.name,
    output_data['tax_id'] = group.properties['tax_id']

    output_data['subscriber'] = {}
    output_data['subscriber']['first_name'] = properties['first_name']
    output_data['subscriber']['middle_name'] = properties['middle_name']
    output_data['subscriber']['last_name'] = properties['last_name']
    output_data['subscriber']['gender'] = properties['sex_indicate']
    output_data['subscriber']['ssn'] = properties['social_security_number']
    output_data['subscriber']['birth_date'] = properties['date_of_birth'].gsub('/', '-')

    output_data['subscriber']['group_or_policy_number'] = benefit_plan.properties['group_id']

    output_data['subscriber']['relationship'] = 'Self'

    output_data['subscriber']['employment_status'] = properties['employment_status']
    output_data['subscriber']['substance_abuse'] = properties['substance_abuse'] == 'Yes'
    output_data['subscriber']['tobacco_use'] = properties['tobacco_use'] == 'Yes'
    output_data['subscriber']['handicapped'] = properties['handicapped'] == 'Yes'

    output_data['subscriber']['address'] = {}
    output_data['subscriber']['address']['city'] = properties['city']
    output_data['subscriber']['address']['county'] = properties['county']
    output_data['subscriber']['address']['line'] = properties['street_address']
    output_data['subscriber']['address']['line2'] = properties['apartment_number']
    output_data['subscriber']['address']['postal_code'] = properties['zip']
    output_data['subscriber']['address']['state'] = properties['state']

    output_data['subscriber']['contacts'] = [
      {
        'primary_communication_number' => properties['phone'],
        'primary_communication_type' => "#{properties['phone_type']} Phone Number",
        'communication_number2' => properties['other_phone'],
        'communication_type2' => "#{properties['other_phone_type']} Phone Number"
      }
    ]

    # TODO: Fill this in
    output_data['subscriber']['benefits'] = [
      {
        'begin_date' => '2014-01-01',
        'benefit_type' => 'Health',
        'coverage_level' => 'Employee Only',
        'late_enrollment' => false,
        'maintenance_type' => 'Addition'
      }
    ]

    output_data['dependents'] = properties
      .map { |key, value| key.match(/^dependent_(\d+)_first_name$/) }
      .compact
      .map { |match| match[1] }
      .map { |name|
        dependent_data = {}

        # Use the subscriber's address
        dependent_data['address'] = output_data['subscriber']['address']

        dependent_data['first_name'] = properties["dependent_#{name}_first_name"]
        dependent_data['middle_name'] = properties["dependent_#{name}_middle_name"]
        dependent_data['last_name'] = properties["dependent_#{name}_last_name"]
        dependent_data['gender'] = properties["dependent_#{name}_sex_indicate"]
        dependent_data['ssn'] = properties["dependent_#{name}_social_security_number"]
        dependent_data['birth_date'] = properties["dependent_#{name}_date_of_birth"].gsub('/', '-')
        dependent_data['relationship'] = properties["dependent_#{name}_relationship"]

        dependent_data
      }

    output_data
  end

  # TODO: Finish erroring
  def state
    if self.errored_on
      'errored'
    elsif self.completed_on
      'completed'
    elsif self.submitted_on
      'submitted'
    elsif self.approved_on
      'approved'
    elsif self.applied_on
      'applied'
    elsif self.declined_on
      'declined'
    elsif self.selected_on
      'selected'
    else
      'not_applied'
    end
  end

  def state_label
    case self.state
    when 'errored'
      'danger'
    when 'completed'
      'success'
    when 'sent'
      'success'
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

