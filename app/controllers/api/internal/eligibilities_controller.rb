class Api::Internal::EligibilitiesController < ApplicationController
  include ApplicationHelper

  protect_from_forgery

  before_filter :ensure_user!
  before_filter :ensure_account!
  before_filter :ensure_broker_or_group_admin!

  def create
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first

    unless account
      error_response('An appropriate account could not be found.')
      return
    end

    carrier = Carrier
      .where('account_id IS NULL OR account_id = ?', current_account.id)
      .where(id: params[:carrier_id])
      .first

    unless carrier
      error_response('An appropriate carrier could not be found.')
      return
    end

    carrier_account = CarrierAccount
      .where(carrier_id: carrier.id, account_id: account.id)
      .first

    unparsed_date_of_birth = params[:date_of_birth]

    unless unparsed_date_of_birth.match(/\d\d\/\d\d\/\d\d\d\d/)
      error_response('Date of birth is not properly formatted.')
      return
    end

    date_of_birth_components = unparsed_date_of_birth.split('/')
    date_of_birth = [
      date_of_birth_components[2],
      date_of_birth_components[0],
      date_of_birth_components[1]
    ].join('-')

    member_id = params[:member_id]
    first_name = params[:first_name]
    last_name = params[:last_name]

    if member_id.blank?
      member_id = nil
    end

    if first_name.blank?
      first_name = nil
    end

    if last_name.blank?
      last_name = nil
    end

    if member_id.nil? && first_name.nil? && last_name.nil?
      error_response('Either first and last name must be provided, or member ID must be provided.')
      return
    end

    if date_of_birth.blank? && member_id.nil?
      error_response('Date of Birth or Member ID must be provided.')
      return
    end

    # Populate either the carrier first and last names, or the carrier name.
    carrier_name = carrier.properties['name']
    carrier_first_name = carrier.properties['first_name']
    carrier_last_name = carrier.properties['last_name']
    if carrier_first_name && carrier_last_name
      carrier_name = [carrier_first_name, carrier_last_name].join(' ')
    end

    carrier_npi = carrier.properties['npi']
    carrier_service_types = carrier.properties['service_types']
    carrier_trading_partner_id = carrier.properties['trading_partner_id']

    if member_id.nil?
      eligibility_query = {
        member: {
          birth_date: date_of_birth,
          first_name: first_name,
          last_name: last_name,
        },
        trading_partner_id: carrier_trading_partner_id
      }
    else
      eligibility_query = {
        member: {
          first_name: first_name,
          last_name: last_name,
          id: member_id
        },
        trading_partner_id: carrier_trading_partner_id
      }
    end

    Rails.logger.info('')
    Rails.logger.info('=======================================')
    Rails.logger.info('Sending the following data to Pokitdok:')
    Rails.logger.info('=======================================')
    Rails.logger.info(eligibility_query.to_json)
    Rails.logger.info('')
    Rails.logger.info('')

    eligibility = pokitdok.eligibility(eligibility_query)

    Rails.logger.info('')
    Rails.logger.info('=================')
    Rails.logger.info('Pokitdok returned:')
    Rails.logger.info('=================')
    Rails.logger.info(eligibility.to_json)
    Rails.logger.info('')
    Rails.logger.info('')

    # ---------------------
    # Eligibility Transform
    # ---------------------

    data = eligibility['data'] || {}
    subscriber_data = data['subscriber'] || {}
    subscriber_address_data = subscriber_data['address'] || {}
    coverage_data = data['coverage'] || {}
    contacts_data = coverage_data['contacts'] || []
    carrier_data = contacts_data.find { |contact| contact['contact_type'] == 'payer' } || {}

    # TODO: SSN

    member_first_name = subscriber_data['first_name']
    member_last_name = subscriber_data['last_name']
    member_name = [member_first_name, member_last_name].compact.join(' ')

    member_raw_date_of_birth = subscriber_data['birth_date']
    member_date_of_birth_components = member_raw_date_of_birth.split('-')
    member_date_of_birth = [
      member_date_of_birth_components[1],
      member_date_of_birth_components[2],
      member_date_of_birth_components[0]
    ].join('/')

    member_zip_code = subscriber_address_data['zipcode']

    member_gender = subscriber_data['gender'].capitalize

    # TODO: Health insurance ID

    carrier_name = carrier_data['name']
    plan_description = coverage_data['plan_description']
    group_description = coverage_data['group_description']
    insurance_type = coverage_data['insurance_type'].try(:upcase)

    group_number = coverage_data['group_number']
    plan_number = coverage_data['plan_number']

    # TODO: RX IIN/BIN

    raw_eligibility_begin_date = coverage_data['eligibility_begin_date'] || ''
    eligibility_begin_date_components = raw_eligibility_begin_date.split('-')
    eligibility_begin_date = [
      eligibility_begin_date_components[1],
      eligibility_begin_date_components[2],
      eligibility_begin_date_components[0]
    ].join('/')

    raw_plan_begin_date = coverage_data['plan_begin_date'] || ''
    plan_begin_date_components = raw_plan_begin_date.split('-')
    plan_begin_date = [
      plan_begin_date_components[1],
      plan_begin_date_components[2],
      plan_begin_date_components[0]
    ].join('/')

    respond_to do |format|
      format.json {
        render json: {
          eligibility: {
            member_name: member_name,
            member_date_of_birth: member_date_of_birth,
            member_zip_code: member_zip_code,
            member_gender: member_gender,
            carrier_name: carrier_name,
            plan_description: plan_description,
            group_description: group_description,
            insurance_type: insurance_type,
            group_number: group_number,
            plan_number: plan_number,
            eligibility_begin_date: eligibility_begin_date,
            plan_begin_date: plan_begin_date
          }
        }
      }
    end
  end
end

