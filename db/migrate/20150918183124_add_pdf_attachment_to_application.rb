class AddPdfAttachmentToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :pdf_attachment_url, :string
  end
end
