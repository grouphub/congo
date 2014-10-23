# Setup config objects for all the YAML files in the config directory
Dir.glob("#{Rails.root}/config/*.yml").each do |path|
  next if path.match(/database\.yml$/)
  next if path.match(/secrets\.yml$/)

  key = File.basename(path)[0...-File.extname(path).length]
  file = File.open(path)
  yaml = YAML::load(file)[Rails.env]
  struct = OpenStruct.new(yaml)

  Congo2::Application.config.send("#{key}=", struct)
end

