module Groups
  class SaveInvoiceFileService
    attr_reader :unique_id, :file, :group, :carrier_id, :directory,
      :file_name, :file_path

    def self.call(*args)
      new(*args).process
    end

    def initialize(group, carrier_id, file)
      @carrier_id= carrier_id
      @group     = group
      @unique_id = SecureRandom.uuid.gsub('-','').upcase
      @directory = 'public/system/carriers_invoices/'
      @file      = file
      @file_name = unique_id + '_' + file.original_filename
      @file_path = File.join(directory, file_name)
    end

    def process
      associate_invoice_with_group if save_file_on_system
    end

    private

    def save_file_on_system
      FileUtils::mkdir_p 'public/system/carriers_invoices/'

      File.open(file_path, "wb") { |f| f.write(file.tempfile.read) }
    end

    def associate_invoice_with_group
      group.carrier_invoice_files.create \
        carrier_id: carrier_id,
        location:   file_path
    end
  end
end
