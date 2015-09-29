require 'csv'

module Memberships
  class CreateFromCSV
    def self.call(*args)
      new(*args).process
    end

    attr_reader :csv_file_rows, :csv_file_headers, :group

    def initialize(csv_file, group)
      @csv_file_rows    = CSV.read(csv_file)
      @csv_file_headers = headers_from_csv_file
      @group            = group
    end

    def process
      employees_from_csv_file.each do |employee|
        Membership.create! \
          account_id: group.account_id,
          group_id: group.id,
          email: employee[:email],
          role_name: "customer"
      end
    end


    private

    def headers_from_csv_file
      csv_headers = csv_file_rows.slice!(0).map do |header|
        if header.include?('/')
          header.downcase.gsub('/', '_').gsub(' ', '_')
        elsif header.include?('-')
          header.downcase.gsub('-', '_').gsub(' ', '_')
        else
          header.downcase.gsub(' ', '_')
        end
      end

      csv_headers.map(&:to_sym)
    end

    def employees_from_csv_file
      employees = []

      csv_file_rows.each do |employee_info|
        employees << Hash[csv_file_headers.zip employee_info]
      end

      employees
    end
  end
end
