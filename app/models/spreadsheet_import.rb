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

  def self.workbook_from_path(path)
    RubyXL::Parser.parse(path)
  end

  def self.log(message)
    output = "SPREADSHEET_IMPORT: #{message}"
    Rails.logger.info(output)
    puts output
  end

  def self.import_workbook(account_id, workbook)
    ActiveRecord::Base.transaction do
      workbook.worksheets.each do |worksheet|
        headings = worksheet[0].cells.map(&:value)
        rows = worksheet[2..-1]
        email_heading_index = headings.index('EMAIL')
        crid_heading_index = headings.index('CRID')
        plid_heading_index = headings.index('PLID')
        groupid_heading_index = headings.index('GROUPID')

        # Check if worksheet is valid.
        if email_heading_index && crid_heading_index && plid_heading_index && groupid_heading_index
          log "Starting on worksheet named \"#{worksheet.sheet_name}\"."
        else
          log "Worksheet named \"#{worksheet.sheet_name}\" does not appear to be a valid worksheet. Skipping."
        end

        rows.each do |row|
          # Extract cells.
          cells = row.cells.map(&:value)

          # Extract basic identifying data.
          email = cells[email_heading_index]
          crid = cells[crid_heading_index]
          plid = cells[plid_heading_index]
          groupid = cells[groupid_heading_index]

          # Skip if empty row.
          if email.blank? && crid.blank? && plid.blank? && groupid.blank?
            log 'EMAIL, CRID, PLID, and GROUPID are blank, leading me to believe this is a blank row. Skipping row.'
            next
          end

          # Bail if email is invalid.
          raise EmailNotProvidedError, cells.to_json if email.blank?

          log "Working on membership for email \"#{email}\"."

          group = self.group_from_groupid(groupid)

          # Bail if valid group cannot be found.
          raise GroupNotProvidedError, cells.to_json unless group

          # Either use an existing membership or create a new one.
          membership = Membership.where(email: email, account_id: account_id).first
          if membership
            puts 'Found an existing membership.'
          else
            membership = Membership.create! \
              email: email,
              account_id: account_id,
              group_id: group.id,
              role_name: 'customer'

            log 'Created a new membership.'
          end

          # Skip if no CRID.
          if crid.blank? || crid == 'None'
            log 'CRID is blank. Skipping application creation.'
            next
          end

          # Skip if no PLID.
          if plid.blank? || plid == 'None'
            log 'PLID is blank. Skipping application creation.'
            next
          end

          carrier = self.carrier_from_crid(crid)

          # Bail if no valid carrier.
          raise CarrierNotProvidedError, cells.to_json unless carrier

          benefit_plan = self.benefit_plan_from_plid(plid)

          # Bail if no valid benefit plan.
          raise BenefitPlanNotProvidedError, cells.to_json unless benefit_plan

          # Transform values into a more manageable form.
          cells_by_heading = cells.each.with_index.inject({}) { |hash, (cell, i)|
            hash[headings[i]] = cell
            hash
          }

          first_name = cells_by_heading['FNAME']
          middle_name = ''
          last_name = cells_by_heading['LNAME']
          sex_indicate = ''
          social_security_number = ''
          date_of_birth = ''

          employment_status = \
            if cells_by_heading['FTE'] == 'FTE'
              'Full-Time'
            elsif cells_by_heading['FTE'] == 'PTE'
              'Part-Time'
            else
              cells_by_heading['FTE']
            end

          street_address = ''
          apartment_number = ''
          city = ''
          state = cells_by_heading['STAT']
          zip = cells_by_heading['ZIP']
          county = ''
          phone = cells_by_heading['PHONE']
          phone_type = 'Home'
          other_phone = ''
          other_phone_type = 'Cell'
          coverage_experience = false
          medical_record_number = ''
          if_yes_most_recent_insurance_carrier = ''
          dates_of_coverage = ''

          # Dependent info.
          dependents = []
          begin
            spouse_age = cells_by_heading['AGESP']
            number_of_dependents = cells_by_heading['DPDT']
            child_ages = []

            (number_of_dependents.to_i - 1).times do |i|
              child_ages << cells_by_heading["AGEC#{i + 1}"]
            end

            unless spouse_age.blank?
              dependents << {
                age: spouse_age,
                relationship: 'spouse'
              }
            end

            child_ages.each do |child_age|
              next if child_age.blank?

              dependents << {
                age: child_age,
                relationship: 'child'
              }
            end
          end

          # Not used.
          unique_employee_id = cells_by_heading['UEID']
          age = cells_by_heading['AGE']
          four_tier_rating_structure = cells_by_heading['4TIER']
          total_monthly_medical_only_gross_rate = cells_by_heading['4TIERRATE']
          total_monthly_employee_only_medical_only_rate = cells_by_heading['4TIEREEOR']

          offered_coverage = \
            if cells_by_heading['OFFR'] == 'Y'
              true
            elsif cells_by_heading['OFFR'] == 'N'
              false
            end

          enrolled_in_coverage =
            if cells_by_heading['ENRL'] == 'Y'
              true
            elsif cells_by_heading['ENRL'] == 'N'
              false
            end

          properties = {}
          properties['first_name'] = first_name
          properties['middle_name'] = middle_name
          properties['last_name'] = last_name
          properties['sex_indicate'] = sex_indicate
          properties['social_security_number'] = social_security_number
          properties['date_of_birth'] = date_of_birth
          properties['employment_status'] = employment_status
          properties['street_address'] = street_address
          properties['apartment_number'] = apartment_number
          properties['city'] = city
          properties['state'] = state
          properties['zip'] = zip
          properties['county'] = county
          properties['phone'] = phone
          properties['phone_type'] = phone_type
          properties['other_phone'] = other_phone
          properties['other_phone_type'] = other_phone_type
          properties['coverage_experience'] = coverage_experience
          properties['medical_record_number'] = medical_record_number
          properties['if_yes_most_recent_insurance_carrier'] = if_yes_most_recent_insurance_carrier
          properties['dates_of_coverage'] = dates_of_coverage

          dependents.each.with_index do |dependent, i|
            properties["dependent_#{i + 1}_first_name"] = ''
            properties["dependent_#{i + 1}_middle_name"] = ''
            properties["dependent_#{i + 1}_last_name"] = ''
            properties["dependent_#{i + 1}_sex_indicate"] = ''
            properties["dependent_#{i + 1}_relationship"] = ''
            properties["dependent_#{i + 1}_medical_record_number_if_any"] = ''
            properties["dependent_#{i + 1}_social_security_number"] = ''
            properties["dependent_#{i + 1}_date_of_birth"] = ''
            properties["dependent_#{i + 1}_coverage_experience"] = ''
            properties["dependent_#{i + 1}_if_yes_most_recent_insurance_carrier"] = ''
            properties["dependent_#{i + 1}_dates_of_coverage"] = ''
          end

          properties['unique_employee_id'] = unique_employee_id
          properties['age'] = age
          properties['four_tier_rating_structure'] = four_tier_rating_structure
          properties['total_monthly_medical_only_gross_rate'] = total_monthly_medical_only_gross_rate
          properties['total_monthly_employee_only_medical_only_rate'] = total_monthly_employee_only_medical_only_rate
          properties['offered_coverage'] = offered_coverage
          properties['enrolled_in_coverage'] = enrolled_in_coverage

          application = Application.new \
            account_id: account_id,
            benefit_plan_id: benefit_plan.id,
            membership_id: membership.id,
            properties: properties

          # TODO: User does not exist at this point, so we cannot set
          # selected_by or declined_by.
          if enrolled_in_coverage
            application.selected_on = DateTime.now
          else
            application.declined_on = DateTime.now
          end

          application.save!

          log 'Created an application.'
        end
      end
    end
  end

  def import_workbook
    self.class.import_workbook(self.account_id, self.workbook)
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

