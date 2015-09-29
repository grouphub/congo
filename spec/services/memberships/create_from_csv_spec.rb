require_relative '../../../app/services/memberships/create_from_csv'

describe Memberships::CreateFromCSV do
  describe '#call' do
    let(:group)    { double :group }
    let(:csv_file) { "#{Rails.root}/spec/data/GroupHub_Employee_Template.csv" }

    it 'creates memberships out of csv file' do
      allow(group).to receive(:id).and_return(1)
      allow(group).to receive(:account_id).and_return(1)

      expect {
        Memberships::CreateFromCSV.call(csv_file, group)
      }.to change(Membership, :count).by(2)
    end
  end
end
