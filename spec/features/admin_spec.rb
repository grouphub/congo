require 'rails_helper'

describe 'Authentication', js: true do

  describe 'as an administrator' do

    it 'allows an administrator to sign in and out' do
      create_admin
      signin_admin
      signout_admin
    end

    it 'allows an administrator to list carriers'

    it 'allows an administrator to create a carrier' do
      create_admin
      signin_admin

      within('ul.sidebar-nav') do
        find('a', text: 'Carriers').click
      end

      within('main') do
        expect(page).to have_content('Carrier Management')

        find('a', text: 'New Carrier').click

        expect(page).to have_content('New Carrier')
        expect(page).to have_content('Add new carrier connection details below.')

        fill_in 'Name', with: 'Blue Cross'
        fill_in 'NPI', with: '123'
        fill_in 'Trading Partner ID', with: '234'
        fill_in 'service_types', with: 'foo, bar, baz_quux'
        fill_in 'Tax ID', with: '345'
        fill_in 'First Name', with: 'Chris'

        scroll_to_element_in 'label[for="last_name"]', 'main'

        fill_in 'Last Name', with: 'Cross'
        fill_in 'Address', with: '123 Somewhere Lane'
        fill_in 'address_2', with: 'Apt. 123'
        fill_in 'City', with: 'Somewhereville'
        fill_in 'State', with: 'CA'
        fill_in 'Zip', with: '94444'
        fill_in 'Phone', with: '444-444-4444'

        all('input[type="submit"]').first.click

        expect(page).to have_content('Carrier Management')
      end

      expect(page).to have_content('Successfully created the carrier.')

      expect(Carrier.count).to eq(1)

      carrier = Carrier.first
      expect(carrier.name).to eq('Blue Cross')
      expect(carrier.slug).to eq('blue_cross')

      carrier_properties = carrier.properties
      expect(carrier_properties['name']).to eq('Blue Cross')
      expect(carrier_properties['npi']).to eq('123')
      expect(carrier_properties['trading_partner_id']).to eq('234')
      expect(carrier_properties['service_types']).to eq(['foo', 'bar', 'baz_quux'])
      expect(carrier_properties['tax_id']).to eq('345')
      expect(carrier_properties['first_name']).to eq('Chris')
      expect(carrier_properties['last_name']).to eq('Cross')
      expect(carrier_properties['address_1']).to eq('123 Somewhere Lane')
      expect(carrier_properties['address_2']).to eq('Apt. 123')
      expect(carrier_properties['city']).to eq('Somewhereville')
      expect(carrier_properties['state']).to eq('CA')
      expect(carrier_properties['zip']).to eq('94444')
      expect(carrier_properties['phone']).to eq('444-444-4444')
    end

    it 'allows an administrator to edit a carrier' do
      create_admin

      Carrier.create! \
        name: 'Blue Cross',
        properties: {
          name: 'Blue Cross',
          npi: '123',
          trading_partner_id: '234',
          service_types: ['foo', 'bar', 'baz_quux'],
          tax_id: '345',
          first_name: 'Chris',
          last_name: 'Cross',
          address_1: '123 Somewhere Lane',
          address_2: 'Apt. 123',
          city: 'Somewhereville',
          state: 'CA',
          zip: '94444',
          phone: '444-444-4444'
        }

      signin_admin

      within('ul.sidebar-nav') do
        find('a', text: 'Carriers').click
      end

      within('main') do
        expect(page).to have_content('Carrier Management')

        find('a', text: 'Blue Cross').click

        expect(page).to have_content('Blue Cross')
        expect(page).to have_content('Edit your carrier connection details below.')

        values = all('input[type=text]').map(&:value)
        expect(values).to eq([
          'Blue Cross',
          '123',
          '234',
          'foo, bar, baz_quux',
          '345',
          'Chris',
          'Cross',
          '123 Somewhere Lane',
          'Apt. 123',
          'Somewhereville',
          'CA',
          '94444',
          '444-444-4444'
        ])

        fill_in 'Name', with: 'Blue Shield'
        fill_in 'NPI', with: '321'
        fill_in 'Trading Partner ID', with: '432'
        fill_in 'service_types', with: 'one, two, three_four'
        fill_in 'Tax ID', with: '543'
        fill_in 'First Name', with: 'Delia'

        scroll_to_element_in 'label[for="last_name"]', 'main'

        fill_in 'Last Name', with: 'Darrenson'
        fill_in 'Address', with: '234 Somewhere Lane'
        fill_in 'address_2', with: 'Apt. 234'
        fill_in 'City', with: 'Anotherville'
        fill_in 'State', with: 'NV'
        fill_in 'Zip', with: '89721'
        fill_in 'Phone', with: '555-555-5555'

        all('input[type="submit"]').first.click
      end

      expect(page).to have_content('Successfully updated the carrier.')

      carrier = Carrier.first
      expect(carrier.name).to eq('Blue Shield')
      expect(carrier.slug).to eq('blue_shield')

      carrier_properties = carrier.properties
      expect(carrier_properties['name']).to eq('Blue Shield')
      expect(carrier_properties['npi']).to eq('321')
      expect(carrier_properties['trading_partner_id']).to eq('432')
      expect(carrier_properties['service_types']).to eq(['one', 'two', 'three_four'])
      expect(carrier_properties['tax_id']).to eq('543')
      expect(carrier_properties['first_name']).to eq('Delia')
      expect(carrier_properties['last_name']).to eq('Darrenson')
      expect(carrier_properties['address_1']).to eq('234 Somewhere Lane')
      expect(carrier_properties['address_2']).to eq('Apt. 234')
      expect(carrier_properties['city']).to eq('Anotherville')
      expect(carrier_properties['state']).to eq('NV')
      expect(carrier_properties['zip']).to eq('89721')
      expect(carrier_properties['phone']).to eq('555-555-5555')
    end

    it 'allows an administrator to delete a carrier'

  end

end

