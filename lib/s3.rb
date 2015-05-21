def upload_to_fakes3(name, tempfile, content_type)
  directory = "#{Rails.root}/tmp/fakes3/congo-attachments/#{name}/.fakes3_metadataFFF"

  FileUtils.mkdir_p(directory)

  File.open("#{directory}/content", "w") do |f|
    f.write(tempfile.read)
  end

  File.open("#{directory}/metadata", "w") do |f|
    md5 = Digest::MD5.file(tempfile).hexdigest
    size = tempfile.size
    modified_date = tempfile.stat.mtime.strftime("%Y-%m-%dT%H:%M:%S.000Z").to_s
    data = {
      md5: md5,
      content_type: content_type,
      size: size,
      modified_date: modified_date,
      custom_metadata: {}
    }

    f.write(data.to_yaml)
  end
end

class S3
  def self.bucket_name
    Rails.application.config.s3.bucket
  end

  def self.endpoint
    Rails.application.config.s3.endpoint
  end

  def self.list
    AWS::S3::Bucket.find(self.bucket_name)
  end

  def self.get(name)
    AWS::S3::S3Object.find(name, self.bucket_name)
  end

  def self.store(name, file, content_type)
    AWS::S3::S3Object.store \
      name,
      file,
      self.bucket_name,
      access: :public_read,
      content_type: content_type
  end

  def self.public_url(name)
    "#{self.endpoint}/#{name}"
  end

  def self.delete(name)
    AWS::S3::S3Object.delete(name, self.bucket_name)
  end

  def self.delete_all
    self.list.map(&:delete)
  end
end

