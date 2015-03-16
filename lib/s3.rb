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

  def self.store(name, file)
    AWS::S3::S3Object.store(name, file, self.bucket_name, access: :public_read)
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

