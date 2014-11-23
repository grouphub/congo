class Api::V1::PropertiesController < ApplicationController
  def account_carriers
    respond_to do |format|
      format.json {
        render json: {
          form: [
            {
              type: 'text',
              name: 'name',
              title: 'Name',
              placeholder: 'Enter a Name'
            },
            {
              type: 'list',
              name: 'carrier_name',
              title: 'Carrier',
              placeholder: 'Select a Carrier',
              items: Carrier.all.map { |carrier|
                {
                  name: carrier.slug,
                  title: carrier.name
                }
              }
            },
            {
              type: 'text',
              name: 'account_number',
              title: 'Account Number',
              placeholder: 'Enter the Account Number'
            },
            {
              type: 'list',
              name: 'account_type',
              title: 'Account Type',
              placeholder: 'Select an Account Type',
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
end

