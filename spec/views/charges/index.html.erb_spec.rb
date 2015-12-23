require 'rails_helper'

RSpec.describe "charges/index", type: :view do
  before(:each) do
    assign(:charges, [
      Charge.create!(
        :name => "Name"
      ),
      Charge.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of charges" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
