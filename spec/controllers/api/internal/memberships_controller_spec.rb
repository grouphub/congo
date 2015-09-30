require 'spec_helper'

describe Api::Internal::MembershipsController do
  let(:broker)  { create(:user, :broker) }
  let(:account) { broker.roles.first.account }

  context 'Broker' do
    describe '#download_employee_template' do
      before do
        @broker_group   = create(:group, account_id: account.id)
      end

      it 'downloads GroupHub Employee Template csv file' do
        get :download_employee_template, {account_id: account.slug, role_id: 'broker',
                                          group_id: @broker_group.slug}, {current_user_id: broker.id}

        expect(response.headers['Content-Type']).to have_content('application/csv')
      end
    end
  end
end
