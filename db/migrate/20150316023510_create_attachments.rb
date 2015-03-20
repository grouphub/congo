class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :benefit_plan_id
      t.integer :group_id
      t.string :filename
      t.string :content_type
      t.string :title
      t.string :url
      t.text :description

      t.timestamps
    end
  end
end
