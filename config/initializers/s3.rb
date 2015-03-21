require 'aws/s3'

access_key = Rails.application.config.s3.access_key
secret_key = Rails.application.config.s3.secret_key
host = Rails.application.config.s3.host
port = Rails.application.config.s3.port

args = {
  access_key_id: access_key,
  secret_access_key: secret_key
}

if host
  args[:server] = host
end

if port
  args[:port] = port
end

AWS::S3::Base.establish_connection!(args)

