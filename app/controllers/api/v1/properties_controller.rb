class Api::V1::PropertiesController < ApplicationController
  def carrier_accounts
    respond_to do |format|
      format.json {
        render json: {
          elements: [
            {
              type: 'text',
              name: 'name',
              title: 'Name',
              placeholder: 'Enter a Name…'
            },
            {
              type: 'list',
              name: 'carrier_name',
              title: 'Carrier',
              value: Carrier.first.slug,
              items: Carrier.all.map { |carrier|
                {
                  name: carrier.slug,
                  title: carrier.name
                }
              }
            },
            {
              type: 'text',
              name: 'broker_number',
              title: 'Broker Number',
              placeholder: 'Enter a Broker Number…'
            },
            {
              type: 'text',
              name: 'brokerage_name',
              title: 'Brokerage Name',
              placeholder: 'Enter a Brokerage Name…'
            },
            {
              type: 'text',
              name: 'tax_id',
              title: 'Tax ID',
              placeholder: 'Enter a Tax ID…'
            },
            {
              type: 'text',
              name: 'account_number',
              title: 'Account Number',
              placeholder: 'Enter the Account Number…'
            },
            {
              type: 'list',
              name: 'account_type',
              title: 'Account Type',
              value: 'broker',
              items: [
                {
                  name: 'broker',
                  title: 'Broker'
                },
                {
                  name: 'tpa',
                  title: 'TPA'
                }
              ]
            },
          ]
        }
      }
    end
  end

  def accounts
    respond_to do |format|
      format.json {
        render json: {
          elements: [
            {
              type: 'text',
              name: 'name',
              title: 'Name',
              placeholder: 'Enter a Company Name…'
            },
            {
              type: 'text',
              name: 'tagline',
              title: 'Tagline',
              placeholder: 'Company Tagline'
            },
            {
              type: 'text',
              name: 'tax_id',
              title: 'Tax ID',
              placeholder: 'Tax ID'
            },
            {
              type: 'text',
              name: 'first_name',
              title: 'Account Contact',
              placeholder: 'Account Contact'
            },
            {
              type: 'text',
              name: 'last_name',
              title: 'Last Name',
              placeholder: 'Account Contact'
            },
            {
              type: 'text',
              name: 'phone',
              title: 'Phone Number',
              placeholder: 'Phone Number'
            }
          ]
        }
      }
    end
  end

  def carriers
    respond_to do |format|
      format.json {
        render json: {
          elements: [
            {
              type: 'text',
              name: 'name',
              title: 'Name',
              placeholder: 'Enter a Carrier Organization Name…'
            },
            {
              type: 'text',
              name: 'npi',
              title: 'NPI',
              placeholder: 'Enter an NPI…'
            },
            {
              type: 'text',
              name: 'trading_partner_id',
              title: 'Trading Partner ID',
              placeholder: 'Enter the Carrier\'s Trading Partner ID…'
            },
            {
              type: 'text',
              name: 'service_types',
              title: 'Service Types (comma-separated, underscored_text)',
              placeholder: 'Enter the Carrier\'s service types…'
            },
            {
              type: 'text',
              name: 'tax_id',
              title: 'Tax ID',
              placeholder: 'Enter the Carrier\'s Tax ID…'
            },
            {
              type: 'text',
              name: 'first_name',
              title: 'Carrier Contact First Name',
              placeholder: 'Enter the Primary Contact\'s First Name for the Carrier…'
            },
            {
              type: 'text',
              name: 'last_name',
              title: 'Carrier Contact Last Name',
              placeholder: 'Enter the Primary Contact\'s First Name for the Carrier…'
            },
            {
              type: 'text',
              name: 'address_1',
              title: 'Address',
              placeholder: 'Enter an Address…'
            },
            {
              type: 'text',
              name: 'address_2',
              placeholder: ''
            },
            {
              type: 'text',
              name: 'city',
              title: 'City',
              placeholder: 'Enter a City…'
            },
            {
              type: 'text',
              name: 'state',
              title: 'State',
              placeholder: 'Enter a State…'
            },
            {
              type: 'text',
              name: 'zip',
              title: 'Zip',
              placeholder: 'Enter a Zip…'
            },
            {
              type: 'text',
              name: 'phone',
              title: 'Phone',
              placeholder: 'Enter a Phone…'
            }
          ]
        }
      }
    end
  end

  def benefit_plans
    respond_to do |format|
      format.json {
        render json: {
          elements: [
            {
              type: 'text',
              name: 'plan_type',
              title: 'Plan type',
              placeholder: 'Enter a plan type…'
            },
            {
              type: 'text',
              name: 'exchange_plan',
              title: 'Exchange plan',
              placeholder: 'Enter an exchange plan…'
            },
            {
              type: 'text',
              name: 'small_group',
              title: 'Small group',
              placeholder: 'Enter a small group…'
            }
          ]
        }
      }
    end
  end

  def groups
    respond_to do |format|
      format.json {
        render json: {
          elements: [
            {
              type: 'text',
              name: 'group_id',
              title: 'Group ID',
              placeholder: 'Enter a group ID…'
            }
          ]
        }
      }
    end
  end
end

