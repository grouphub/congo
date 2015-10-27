require_relative "#{Rails.root}/app/services/groups/save_invoice_file_service"

describe Groups::SaveInvoiceFileService do
  describe '#call' do
    let(:carrier_invoice_files_object) { double :carrier_invoice_files }
    let(:group)           { double :group }
    let(:carrier_invoice_file) { double(
      :file,
      original_filename: 'carrier_invoice.txt',
      tempfile: File.new("#{Rails.root}/spec/data/carrier_invoice.txt")
    )}

    subject { Groups::SaveInvoiceFileService.(group, 1, carrier_invoice_file) }

    before :each do
      allow(group).to receive(:carrier_invoice_files).with(no_args).and_return(carrier_invoice_files_object)
      allow(carrier_invoice_files_object).to receive(:create).with(any_args)
    end

    after :all do
      Dir.entries('public/system/carriers_invoices').each do |file|
        FileUtils.rm("public/system/carriers_invoices/#{file}") if file.include? 'carrier_invoice.txt'
      end
    end

    describe '#process' do
      it 'creates a CarrierInvoiceFiles object' do
        expect(group).to receive(:carrier_invoice_files).with(no_args)
        expect(carrier_invoice_files_object).to receive(:create).with(any_args).and_return(carrier_invoice_files_object)

        subject
      end

      it 'creates a file on public/system/carriers_invoices/' do
        subject

        expect(
          Dir.entries('public/system/carriers_invoices').inject(:+).include? 'carrier_invoice.txt'
        ).to be true
      end
    end
  end
end
