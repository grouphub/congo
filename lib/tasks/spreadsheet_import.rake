namespace :spreadsheet_import do
  task :import => :environment do
    path = ENV['SPREADSHEET_PATH']
    account_id = ENV['ACCOUNT_ID']

    raise 'SPREADSHEET_PATH must be provided.' unless path
    raise 'ACCOUNT_ID must be provided.' unless path

    SpreadsheetImport.import_workbook \
      account_id,
      SpreadsheetImport.workbook_from_path(path)
  end
end

