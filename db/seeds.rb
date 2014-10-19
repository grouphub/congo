# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Dir.glob("#{Rails.root}/db/seeds/**/*.rb").each do |path|
  puts "Loading #{path}..."

  begin
    load(path)
  rescue StandardError => e
    print "Error loading #{path} I think...\n\n#{e.message}\n\n#{e.backtrace.join("\n")}\n\n"
    exit
  end
end

