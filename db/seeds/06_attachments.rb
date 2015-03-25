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

if Rails.env.development?
  title = 'Sample Attachment'
  description = 'An attachment for a group.'
  name = ThirtySix.generate
  tempfile = File.open("#{Rails.root}/spec/data/sample-attachment.png")
  content_type = 'image/png'
  url = S3.public_url(name)

  upload_to_fakes3(name, tempfile, 'image/png')

  Attachment.create! \
    group_id: Group.where(name: 'My Group').first.id,
    title: title,
    filename: name,
    description: description,
    content_type: content_type,
    url: url
end

if Rails.env.development?
  title = 'Sample Attachment'
  description = 'An attachment for a benefit plan.'
  name = ThirtySix.generate
  tempfile = File.open("#{Rails.root}/spec/data/sample-attachment-2.png")
  content_type = 'image/png'
  url = S3.public_url(name)

  upload_to_fakes3(name, tempfile, 'image/png')

  Attachment.create! \
    benefit_plan_id: BenefitPlan.where(name: 'Best Health Insurance PPO').first.id,
    title: title,
    filename: name,
    description: description,
    content_type: content_type,
    url: url
end

