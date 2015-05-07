class SpreadsheetImport < ActiveRecord::Base
  class EmailNotProvidedError < StandardError
  end

  class CarrierNotProvidedError < StandardError
  end

  class BenefitPlanNotProvidedError < StandardError
  end

  class GroupNotProvidedError < StandardError
  end

  def self.carrier_from_crid(crid)
    Carrier.where(name: crid).first
  end

  def self.benefit_plan_from_plid(plid)
    BenefitPlan.where(name: plid).first
  end

  def self.group_from_groupid(groupid)
    Group.where(name: groupid).first
  end

  def import_workbook
    ActiveRecord::Base.transaction do
      self.workbook.worksheets.each do |worksheet|
        headings, _ = workbook[0..1]
        rows = workbook[2..-1]
        email_heading_index = headings.index('EMAIL')
        crid_heading_index = headings.index('CRID')
        plid_heading_index = headings.index('PLID')
        groupid_heading_index = headings.index('GROUPID')

        rows.each do |row|
          email = row[email_heading_index]

          raise EmailNotProvidedError, row.to_json if email.blank?

          carrier = self.class.carrier_from_crid(row[crid_heading_index])

          raise CarrierNotProvidedError, row.to_json unless carrier

          benefit_plan = self.class.benefit_plan_from_plid(row[plid_heading_index])

          raise BenefitPlanNotProvidedError, row.to_json unless carrier

          group = self.group_from_groupid(row[groupid_heading_index])

          raise GroupNotProvidedError, row.to_json unless carrier

          membership = Membership.where(email: email, account_id: self.account_id).first

          unless membership
            membership = Membership.create! \
              email: email,
              account_id: account_id,
              group_id: group.id,
              role_name: 'customer'
          end

          cells_by_heading = row.each.with_index.inject({}) { |hash, (cell, i)|
            hash[headings[i]] = cell
            hash
          }

          # Any of these may have a value, "None", or blank
          unique_employee_id = cells_by_heading['UEID']
          first_name = cells_by_heading['FNAME']
          last_name = cells_by_heading['LNAME']
          phone = cells_by_heading['PHONE']
          state = cells_by_heading['STAT']
          zip = cells_by_heading['ZIP']
          full_time_part_time = cells_by_heading['FTE'] # Either FTE or PTE
          offered_coverage = cells_by_heading['OFFR'] # Y or N
          enrolled_in_coverage = cells_by_heading['ENRL'] # Y or N
          age = cells_by_heading['AGE']
          spouse_age = cells_by_heading['AGESP']
          number_of_dependents = cells_by_heading['DPDT']
          child_ages = []
          four_tier_rating_structure = cells_by_heading['4TIER']
          total_monthly_medical_only_gross_rate = cells_by_heading['4TIERRATE']
          total_monthly_employee_only_medical_only_rate = cells_by_heading['4TIEREEOR']

          (number_of_dependents.to_i - 1).times do |i|
            child_ages << cell_by_heading["AGEC#{i + 1}"]
          end

          # TODO: Fill this in
          properties = {

          }

          Application.create! \
            account_id: self.account_id,
            benefit_plan_id: self.benefit_plan.id,
            membership_id: membership.id,
            properties: properties
        end
      end
    end
  end

  def workbook
    uri = URI(self.url)
    # TODO: Remove this
    uri = URI('http://thefifthcircuit.stuff.s3.amazonaws.com/GroupHub%20Group%20Import.xlsx')

    workbook = nil

    tempfile = Tempfile.new('spreadsheet')
    tempfile.binmode

    begin
      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new(uri)

        http.request(request) do |response|
          response.read_body do |chunk|
            tempfile.write(chunk)
          end

          tempfile.rewind

          workbook = RubyXL::Parser.parse(tempfile.path)
        end
      end
    ensure
      tempfile.close
      tempfile.unlink
    end

    workbook
  end
end
