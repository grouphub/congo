require 'pokitdok'

class Api::V1::EligibilitiesController < ApplicationController
  def create
    account_slug = params[:account_id]
    account = Account.where(slug: account_slug).first

    carrier_account_id = params[:carrier_account_id]
    carrier_account = CarrierAccount
      .where(id: carrier_account_id, account_id: account.id)
      .includes(:carrier)
      .first

    carrier = carrier_account.carrier

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

    if date_of_birth.blank?
      error_response('Date of birth cannot be blank.')
      return
    end

    pokitdok = PokitDok::PokitDok.new \
      Rails.application.config.pokitdok.client_id,
      Rails.application.config.pokitdok.client_secret

    # Populate either the carrier name or the carrier first and last names
    #
    # TODO: Add separate organization name to carrier and use instead of "name".
    #
    carrier_name = nil
    carrier_first_name = carrier.properties['first_name']
    carrier_last_name = carrier.properties['last_name']
    unless carrier_first_name && carrier_last_name
      carrier_first_name = carrier.properties['first_name']
      carrier_last_name = carrier.properties['last_name']
    end

    carrier_npi = carrier.properties['npi']
    carrier_service_types = carrier.properties['service_types']
    carrier_trading_partner_id = carrier.properties['trading_partner_id']

    # Eligibility
    eligibility_query = {
      member: {
          birth_date: date_of_birth,
          first_name: first_name,
          last_name: last_name#,
    #      id: member_id
      },
   #   provider: {
    #      organization_name: carrier_name,
     #     first_name: carrier_first_name,
      #    last_name: carrier_last_name,
       #   npi: carrier_npi
     # },
     # service_types: carrier_service_types,
      trading_partner_id: carrier_trading_partner_id
    }

    Rails.logger.info('')
    Rails.logger.info('=======================================')
    Rails.logger.info('Sending the following data to Pokitdok:')
    Rails.logger.info('=======================================')
    Rails.logger.info(eligibility_query.to_json)
    Rails.logger.info('')
    Rails.logger.info('')

    eligibility = pokitdok.eligibility(eligibility_query)

    # TODO: Return these fields:
    #
    #   * SSN
    #   * Member Name
    #   * Member Date of Birth
    #   * Member Zip Code
    #   * Member Sex
    #   * Health Insurance ID
    #   * Plan Name
    #   * Plan Number
    #   * Rx IIN/BIN
    #
    respond_to do |format|
      format.json {
        render json: {
          eligibility: JSON.pretty_generate(eligibility)
        }
      }
    end
  end
end

