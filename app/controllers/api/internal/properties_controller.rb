class Api::Internal::PropertiesController < ApplicationController
  protect_from_forgery

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
              placeholder: 'Account Contact First Name'
            },
            {
              type: 'text',
              name: 'last_name',
              title: 'Last Name',
              placeholder: 'Account Contact Last Name'
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
end

