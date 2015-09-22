require 'spec_helper'

describe Api::Internal::BenefitPlansController do

  describe 'GET #index' do

    # NOTE: We currently do not show benefits whose account ID is admin. Rather,
    # it is expected that admin-created carriers have a nil account ID.
    before do
      create_admin
      create_broker

      @their_account = Account.create! \
        name: 'Second Account'

      @ids_to_identifiers = {}
      2.times do |i|
        [true, false].each do |is_benefit_plan_added|
          [true, false].each do |is_carrier_added|
            [:admin, :nil, :yours, :theirs].each do |who_created|
              [true, false].each do |is_plan_enabled|
                identifier = [
                  who_created.to_s.capitalize,
                  (is_benefit_plan_added ? 'Benefit Plan Added' : 'Benefit Plan Not Added'),
                  (is_plan_enabled ? 'Enabled' : 'Disabled'),
                  (is_carrier_added ? 'Carrier Added' : 'Carrier Not Added'),
                  (i + 1).to_s
                ].join(' ')

                account = nil
                if who_created == :admin
                  account = Account.where(name: 'Admin').first
                elsif who_created == :nil
                  account = nil
                elsif who_created == :yours
                  account = Account.where(name: 'First Account').first
                elsif who_created == :theirs
                  account = @their_account
                else
                  raise "Value for `who_created` of `#{who_created.inspect}` is not valid."
                end

                carrier = Carrier.create! \
                  account_id: account.try(:id),
                  name: "#{identifier} Carrier",
                  properties: {}

                benefit_plan = BenefitPlan.create! \
                  account_id: account.try(:id),
                  carrier_id: carrier.id,
                  name: "#{identifier} Benefit Plan",
                  is_enabled: is_plan_enabled,
                  properties: {}

                @ids_to_identifiers[benefit_plan.id] = identifier

                carrier_account = nil
                if is_carrier_added
                  carrier_account = CarrierAccount.create! \
                    account_id: account.try(:id),
                    carrier_id: carrier.id,
                    properties: {}
                end

                if is_benefit_plan_added
                  AccountBenefitPlan.create! \
                    account_id: account.try(:id),
                    carrier_id: carrier.id,
                    carrier_account_id: carrier_account.try(:id),
                    benefit_plan_id: benefit_plan.try(:id)
                end
              end
            end
          end
        end
      end

      @current_user = User.where(email: 'barry@broker.com').first
      @current_account = Account.where(name: 'First Account').first
      @current_role = Role.where(user_id: @current_user.id, account_id: @current_account.id, name: 'broker').first
    end

    context 'displaying plans for only activated carriers (what a broker sees)' do
      it 'renders a list of benefit plans' do
        get :index,
          {
          format: 'json',
          account_id: @current_account.slug,
          role_id: @current_role.id,
          only_activated_carriers: 'true'
        },
        {
          current_user_id: @current_user.id
        }

        response_data = JSON.load(response.body)
        benefit_plans_data = response_data['benefit_plans']
        identifiers = benefit_plans_data.map { |benefit_plan|
          @ids_to_identifiers[benefit_plan['id']]
        }

        expect(identifiers).to eq([
          'Yours Benefit Plan Added Enabled Carrier Added 1',
          'Yours Benefit Plan Added Disabled Carrier Added 1',
          'Yours Benefit Plan Not Added Enabled Carrier Added 1',
          'Yours Benefit Plan Not Added Disabled Carrier Added 1',
          'Yours Benefit Plan Added Enabled Carrier Added 2',
          'Yours Benefit Plan Added Disabled Carrier Added 2',
          'Yours Benefit Plan Not Added Enabled Carrier Added 2',
          'Yours Benefit Plan Not Added Disabled Carrier Added 2'
        ])
      end
    end

    context 'displaying plans for only activated benefit plans (what a customer sees)' do
      it 'renders a list of benefit plans' do
        get :index,
          {
          format: 'json',
          account_id: @current_account.slug,
          role_id: @current_role.id,
          only_activated: 'true'
        },
        {
          current_user_id: @current_user.id
        }

        response_data = JSON.load(response.body)
        benefit_plans_data = response_data['benefit_plans']
        identifiers = benefit_plans_data.map { |benefit_plan|
          @ids_to_identifiers[benefit_plan['id']]
        }

        expect(identifiers).to eq([
          'Yours Benefit Plan Added Enabled Carrier Added 1',
          'Yours Benefit Plan Added Enabled Carrier Not Added 1',
          'Yours Benefit Plan Added Enabled Carrier Added 2',
          'Yours Benefit Plan Added Enabled Carrier Not Added 2'
        ])
      end
    end

    context 'displaying any plans' do
      it 'renders a list of benefit plans' do
        get :index,
          {
          format: 'json',
          account_id: @current_account.slug,
          role_id: @current_role.id
        },
        {
          current_user_id: @current_user.id
        }

        response_data = JSON.load(response.body)
        benefit_plans_data = response_data['benefit_plans']
        identifiers = benefit_plans_data.map { |benefit_plan|
          @ids_to_identifiers[benefit_plan['id']]
        }

        expect(identifiers).to eq([
          'Nil Benefit Plan Added Enabled Carrier Added 1',
          'Yours Benefit Plan Added Enabled Carrier Added 1',
          'Yours Benefit Plan Added Disabled Carrier Added 1',
          'Nil Benefit Plan Added Enabled Carrier Not Added 1',
          'Yours Benefit Plan Added Enabled Carrier Not Added 1',
          'Yours Benefit Plan Added Disabled Carrier Not Added 1',
          'Nil Benefit Plan Not Added Enabled Carrier Added 1',
          'Yours Benefit Plan Not Added Enabled Carrier Added 1',
          'Yours Benefit Plan Not Added Disabled Carrier Added 1',
          'Nil Benefit Plan Not Added Enabled Carrier Not Added 1',
          'Yours Benefit Plan Not Added Enabled Carrier Not Added 1',
          'Yours Benefit Plan Not Added Disabled Carrier Not Added 1',
          'Nil Benefit Plan Added Enabled Carrier Added 2',
          'Yours Benefit Plan Added Enabled Carrier Added 2',
          'Yours Benefit Plan Added Disabled Carrier Added 2',
          'Nil Benefit Plan Added Enabled Carrier Not Added 2',
          'Yours Benefit Plan Added Enabled Carrier Not Added 2',
          'Yours Benefit Plan Added Disabled Carrier Not Added 2',
          'Nil Benefit Plan Not Added Enabled Carrier Added 2',
          'Yours Benefit Plan Not Added Enabled Carrier Added 2',
          'Yours Benefit Plan Not Added Disabled Carrier Added 2',
          'Nil Benefit Plan Not Added Enabled Carrier Not Added 2',
          'Yours Benefit Plan Not Added Enabled Carrier Not Added 2',
          'Yours Benefit Plan Not Added Disabled Carrier Not Added 2'
        ])
      end
    end

  end
end
