require 'spec_helper'

describe Api::Internal::MembershipsController do
  context 'Broker' do
    describe '#download_employee_template' do
      before do
        create_broker

        @broker_account = Role.find_by_name('broker').account
        @broker_group   = create(:group, account_id: @broker_account.id)
        @current_user   = User.where(email: 'barry@broker.com').first
      end

      it 'downloads GroupHub Employee Template csv file' do
        get :download_employee_template, {account_id: @broker_account.slug, role_id: 'broker',
                                          group_id: @broker_group.slug}, {current_user_id: @current_user.id}

        expect(response.headers['Content-Type']).to have_content('application/csv')
      end
    end
  end
end
