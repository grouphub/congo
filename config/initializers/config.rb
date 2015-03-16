# Setup config objects for all the YAML files in the config directory
Dir.glob("#{Rails.root}/config/*.yml").each do |path|
  next if path.match(/database\.yml$/)
  next if path.match(/secrets\.yml$/)

  key = File.basename(path)[0...-File.extname(path).length]
  contents = File.read(path)
  erb = ERB.new(contents).result

  begin
    yaml = YAML::load(erb)[Rails.env]
  rescue StandardError => e
    STDERR.puts "An error occurred parsing YAML config file \"#{path}\"."
    STDERR.puts erb
    raise e
  end

  struct = OpenStruct.new(yaml)

  Rails.application.config.send("#{key}=", struct)
end

