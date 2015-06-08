namespace :plans do
  def value(item)
    return '$%.0f' % item.value if item.value.is_a?(Numeric)
    item.value.strip
  end

  def generate_html_for_worksheet(worksheet)
    output = {}

    # Plan Description
    second_row = worksheet[1]
    third_row = worksheet[2]
    fourth_row = worksheet[3]
    fifth_row = worksheet[4]
    fifth_row = worksheet[4]

    output[:plan_name] = second_row[0].value.strip
    output[:plan_type] = third_row[1].value.strip.match(/^(\w+) Individual$/)[1]

    output[:deductible_individual] = value fourth_row[1]
    output[:deductible_family] = value fourth_row[2]
    output[:max_out_of_pocket_individual] = value fifth_row[1]
    output[:max_out_of_pocket_family] = value fifth_row[2]

    # Type of Visit
    eighth_row = worksheet[7]
    ninth_row = worksheet[8]
    tenth_row = worksheet[9]
    eleventh_row = worksheet[10]

    output[:doctor_visits_plan] = value eighth_row[1]
    output[:doctor_visits_non_plan] = value eighth_row[2]
    output[:specialist_visits_plan] = value ninth_row[1]
    output[:specialist_visits_non_plan] = value ninth_row[2]
    output[:xray_plan] = value tenth_row[1]
    output[:xray_non_plan] = value tenth_row[2]
    output[:mri_plan] = value eleventh_row[1]
    output[:mri_non_plan] = value eleventh_row[2]

    # Prescriptions
    fourteenth_row = worksheet[13]
    fifteenth_row = worksheet[14]
    sixteenth_row = worksheet[15]
    seventeenth_row = worksheet[16]

    output[:drug_deductible_plan] = value fourteenth_row[1]
    output[:drug_deductible_non_plan] = value fourteenth_row[2]
    output[:generic_plan] = value fifteenth_row[1]
    output[:generic_non_plan] = value fifteenth_row[2]
    output[:brand_plan] = value sixteenth_row[1]
    output[:brand_non_plan] = value sixteenth_row[2]
    output[:specialty_plan] = value seventeenth_row[1]
    output[:specialty_non_plan] = value seventeenth_row[2]

    # Hospital Services
    twentieth_row = worksheet[19]
    twenty_first_row = worksheet[20]
    twenty_second_row = worksheet[21]

    output[:emergency_room_plan] = value twentieth_row[1]
    output[:emergency_room_non_plan] = value twentieth_row[2]
    output[:hospital_stay_plan] = value twenty_first_row[1]
    output[:hospital_stay_non_plan] = value twenty_first_row[2]
    output[:child_birth_plan] = value twenty_second_row[1]
    output[:child_birth_non_plan] = value twenty_second_row[2]

    # Mental Health
    twenty_fifth_row = worksheet[24]
    twenty_sixth_row = worksheet[25]
    twenty_seventh_row = worksheet[26]

    output[:mental_outpatient_plan] = value twenty_fifth_row[1]
    output[:mental_outpatient_non_plan] = value twenty_fifth_row[2]
    output[:mental_inpatient_plan] = value twenty_sixth_row[1]
    output[:mental_inpatient_non_plan] = value twenty_sixth_row[2]
    output[:substance_outpatient_plan] = value twenty_seventh_row[1]
    output[:substance_outpatient_non_plan] = value twenty_seventh_row[2]

    # Medical Emergencies
    thirtieth_row = worksheet[29]
    thirty_first_row = worksheet[30]
    thirty_second_row = worksheet[21]

    output[:emergency_room_plan] = value thirtieth_row[1]
    output[:emergency_room_non_plan] = value thirtieth_row[2]
    output[:emergency_medical_plan] = value thirty_first_row[1]
    output[:emergency_medical_non_plan] = value thirty_first_row[2]
    output[:urgent_care_plan] = value thirty_second_row[1]
    output[:urgent_care_non_plan] = value thirty_second_row[2]

    plan_template = File.read("#{Rails.root}/app/views/templates/plan.html.erb")
    struct = OpenStruct.new(output)

    rendered = ERB
      .new(
        plan_template
          .gsub('{{', '<%=')
          .gsub('}}', '%>')
      )
      .result(
        struct.instance_eval {
          binding
        }
      )
      .gsub(/^\s+/m, '')

    FileUtils.mkdir_p("#{Rails.root}/tmp/plans")

    File.open("#{Rails.root}/tmp/plans/#{output[:plan_name]}.html", 'w') do |f|
      f.puts(rendered)
    end
  end

  desc 'Generate HTML for a plan XSLX spreadsheet at PLAN_PATH'
  task :htmlize => :environment do
    path = ENV['PLAN_PATH']
    workbook = RubyXL::Parser.parse(path)

    workbook.worksheets.each do |worksheet|
      generate_html_for_worksheet(worksheet)
    end
  end
end
