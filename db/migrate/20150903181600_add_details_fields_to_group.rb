class AddDetailsFieldsToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :number_of_members, :integer
    add_column :groups, :industry, :string
    add_column :groups, :website, :string
    add_column :groups, :phone_number, :string
    add_column :groups, :zip_code, :integer
    add_column :groups, :tax_id, :integer
  end
end
