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

    member_id = params[:member_id]
    date_of_birth = params[:date_of_birth]
    first_name = params[:first_name]
    last_name = params[:last_name]

    if member_id.blank?
      error_response('Member ID cannot be blank.')
      return
    end

    if date_of_birth.blank?
      error_response('Date of birth cannot be blank.')
      return
    end

    if first_name.blank?
      error_response('First name cannot be blank.')
      return
    end

    if last_name.blank?
      error_response('First name cannot be blank.')
      return
    end

    pokitdok = PokitDok::PokitDok.new \
      Rails.application.config.pokitdok.client_id,
      Rails.application.config.pokitdok.client_secret

    # Eligibility
    eligibility_query = {
      member: {
          birth_date: date_of_birth,
          first_name: first_name,
          last_name: last_name,
          id: member_id
      },
      provider: {
          organization_name: carrier.name,
          first_name: carrier.properties.first_name,
          last_name: carrier.properties.last_name,
          npi: carrier.properties.npi
      },
      service_types: carrier.properties.service_types,
      trading_partner_id: carrier.properties.trading_partner_id
    }

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

