require_relative "#{Rails.root}/app/services/memberships/create_from_csv"

describe Memberships::CreateFromCSV do
  describe '#call' do
    let(:group)    { double :group, id: 1, account_id: 1 }
    let(:csv_file) { "#{Rails.root}/spec/data/GroupHub_Employee_Template.csv" }

    subject { Memberships::CreateFromCSV.(csv_file, group) }

    describe "#process" do
      it 'creates memberships out of csv file' do
        expect { subject }.
          to change(Membership, :count).by(2)
      end
    end
  end
end
