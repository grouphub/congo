require 'spec_helper'

describe Group do
  it 'validates uniqueness of name' do
    Group.create(
      account_id: 5,
      name: "My group",
      is_enabled: nil,
      description_markdown: nil,
      description_html: ""
    )

    group = Group.create(
      account_id: 5,
      name: "My group",
      is_enabled: nil,
      description_markdown: nil,
      description_html: ""
    )

    expect(group.errors[:name]).to include("has already been taken")
  end
end
