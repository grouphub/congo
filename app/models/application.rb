class Application < ActiveRecord::Base
  include Propertied

  belongs_to :account
  belongs_to :benefit_plan
  belongs_to :membership

  has_many :attempts

  # {
  #   "first_name": "Candice",
  #   "middle_name": "C.",
  #   "last_name": "Customer",
  #   "sex_indicate": "Female",
  #   "social_security_number": "444-44-4444",
  #   "date_of_birth": "04/04/1984",
  #   "street_address": "444 Carrie Ct.",
  #   "apartment_number": "44",
  #   "city": "Cambridge",
  #   "state": "CA",
  #   "zip": "44444",
  #   "county": "Contra Costa",
  #   "phone": "(444) 444-4444", // TODO: ?
  #   "other_phone": "(444) 444-5555", // TODO: ?
  #   "coverage_experience": "Yes", // TODO: ?
  #   "medical_record_number": "4444444", // TODO: ?
  #   "if_yes_most_recent_insurance_carrier": "Anthem Blue Cross", // TODO: ?
  #   "dates_of_coverage": "04/2014-08/2014", // TODO: ?
  #
  #   "dependent_1_first_name": "Corwin",
  #   "dependent_1_middle_name": "C.",
  #   "dependent_1_last_name": "Customer",
  #   "dependent_1_sex_indicate": "Male",
  #   "dependent_1_medical_record_number_if_any": "4444444", TODO: ?
  #   "dependent_1_social_security_number": "444-44-4445",
  #   "dependent_1_date_of_birth": "04/04/2004",
  #   "dependent_1_coverage_experience": "Yes", TODO: ?
  #   "dependent_1_if_yes_most_recent_insurance_carrier": "Anthem Blue Cross", TODO: ?
  #   "dependent_1_dates_of_coverage": "04/2014-08/2014", TODO: ?
  #
  #   // TODO: ?
  #   "parent_or_legal_guardian_covered": "Yes",
  #   "parent_or_legal_guardian_first_name": "Cal",
  #   "parent_or_legal_guardian_middle_name": "C.",
  #   "parent_or_legal_guardian_last_name": "Customer",
  #   "parent_or_legal_guardian_sex_indicate": "Male",
  #   "parent_or_legal_guardian_medical_record_number_if_any": "4444444",
  #   "parent_or_legal_guardian_social_security_number": "444-44-4443",
  #   "parent_or_legal_guardian_date_of_birth": "04/04/1982",
  #   "parent_or_legal_guardian_rel_to_applicant": "Spouse",
  #   "parent_or_legal_guardian_language_spoken": "Spanish",
  #   "parent_or_legal_guardian_language_read": "Spanish",
  #   "parent_or_legal_guardian_same_address": "No",
  #   "parent_or_legal_guardian_street_address": "444 Carrie Ct.",
  #   "parent_or_legal_guardian_apartment_number": "44",
  #   "parent_or_legal_guardian_city": "Cambridge",
  #   "parent_or_legal_guardian_state": "CA",
  #   "parent_or_legal_guardian_zip": "44444",
  #   "parent_or_legal_guardian_county": "Contra Costa",
  #   "parent_or_legal_guardian_phone": "(444) 444-4444",
  #   "parent_or_legal_guardian_other_phone": "(444) 444-5555",
  #
  #   // TODO: ?
  #   "authorized_representative": "Yes",
  #   "authorized_representative_first_name": "Cal",
  #   "authorized_representative_middle_name": "C.",
  #   "authorized_representative_last_name": "Customer",
  #   "authorized_representative_street_address": "444 Carrie Ct.",
  #   "authorized_representative_apartment_number": "44",
  #   "authorized_representative_city": "Cambridge",
  #   "authorized_representative_street": "CA",
  #   "authorized_representative_zip": "44444",
  #   "authorized_representative_phone": "(444) 444-4444",
  #   "authorized_representative_primary_applicant": "Cal C. Customer",
  #   "authorized_representative_date": "03/10/2015"
  # }

  def to_pokitdok
    account = self.account
    benefit_plan = self.benefit_plan
    membership = self.membership
    properties = self.properties
    output_data = {}

    # TODO: Validation
    # TODO: Form validation

    output_data['action'] = 'Change'

    # TODO: Fill this in
    output_data['dependents'] = properties
      .map { |key, value| key.match(/^dependent_(\d+)_first_name$/) }
      .compact
      .map { |match| match[1] }
      .map { |name|
        # properties["dependent_#{name}_first_name"]
        # properties["dependent_#{name}_middle_name"]
        # properties["dependent_#{name}_last_name"]
        # properties["dependent_#{name}_sex_indicate"]
        # properties["dependent_#{name}_medical_record_number_if_any"]
        # properties["dependent_#{name}_social_security_number"]
        # properties["dependent_#{name}_date_of_birth"]
        # properties["dependent_#{name}_coverage_experience"]
        # properties["dependent_#{name}_if_yes_most_recent_insurance_carrier"]
        # properties["dependent_#{name}_dates_of_coverage"]

        {}
      }

    # TODO: Fill this in
    output_data['payer'] = {
      'tax_id' => '111222333'
    }

    output_data['purpose'] = 'Original'
    output_data['reference_number'] = '12456' # TODO: Do we need this?
    output_data['trading_partner_id'] = 'MOCKPAYER' # TODO: Fill this in

    # TODO: Fill this in
    output_data['sponsor'] = {
      'name' => 'Acme, Inc.' # TODO: Fill this in
      'tax_id' => '999888777' # TODO: Fill this in
    }

    output_data['subscriber'] = {}
    output_data['subscriber']['first_name'] = properties['first_name']
    output_data['subscriber']['middle_name'] = properties['middle_name']
    output_data['subscriber']['last_name'] = properties['last_name']
    output_data['subscriber']['gender'] = properties['sex_indicate']
    output_data['subscriber']['ssn'] = properties['social_security_number']
    output_data['subscriber']['birth_date'] = properties['date_of_birth'].gsub('/', '-')
    output_data['subscriber']['benefit_status'] = 'Active' # TODO: Fill this in
    output_data['subscriber']['eligibility_begin_date'] = '2014-01-01' # TODO: Fill these in
    output_data['subscriber']['employment_status'] = 'Full-time' # TODO: Fill these in
    output_data['subscriber']['group_or_policy_number'] = '123456001' # TODO: Fill these in
    output_data['subscriber']['handicapped'] = false # TODO: Fill these in
    output_data['subscriber']['maintenance_reason'] = 'Active' # TODO: Fill these in
    output_data['subscriber']['maintenance_type'] = 'Addition' # TODO: Fill these in
    output_data['subscriber']['member_id'] = '123456789' # TODO: Fill these in
    output_data['subscriber']['relationship'] = 'Self' # TODO: Fill these in. Dependent on authorized representative
    output_data['subscriber']['subscriber_number'] = '123456789' # TODO: Fill these in
    output_data['subscriber']['substance_abuse'] = false # TODO: Fill these in
    output_data['subscriber']['tobacco_use'] = false # TODO: Fill these in

    output_data['subscriber']['address'] = {}
    output_data['subscriber']['address']['city'] = properties['city']
    output_data['subscriber']['address']['county'] = properties['county']
    output_data['subscriber']['address']['line'] = properties['street_address']
    output_data['subscriber']['address']['line2'] = properties['apartment_number']
    output_data['subscriber']['address']['postal_code'] = properties['zip']
    output_data['subscriber']['address']['state'] = properties['state']

    # TODO: Fill this in
    output_data['subscriber']['benefits'] = [
      {
        'begin_date': '2014-01-01',
        'benefit_type': 'Health',
        'coverage_level': 'Employee Only',
        'late_enrollment': false,
        'maintenance_type': 'Addition'
      }
    ]

    # TODO: Fill this in
    output_data['subscriber']['contacts'] = [
      {
        'primary_communication_number' => '7172343334',
        'primary_communication_type' => 'Home Phone Number',
        'communication_number2' => '7172341240',
        'communication_type2' => 'Work Phone Number'
      }
    ]

    output_data
  end

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

