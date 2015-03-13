# Setup config objects for all the YAML files in the config directory
Dir.glob("#{Rails.root}/config/*.yml").each do |path|
  next if path.match(/database\.yml$/)
  next if path.match(/secrets\.yml$/)

  key = File.basename(path)[0...-File.extname(path).length]
  contents = File.read(path)
  erb = ERB.new(contents).result
  yaml = YAML::load(erb)[Rails.env]
  struct = OpenStruct.new(yaml)

  Rails.application.config.send("#{key}=", struct)
end

