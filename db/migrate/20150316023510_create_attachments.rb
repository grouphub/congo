class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :benefit_plan_id
      t.string :filename
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
