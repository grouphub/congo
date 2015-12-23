require 'rails_helper'

RSpec.describe "charges/show", type: :view do
  before(:each) do
    @charge = assign(:charge, Charge.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
