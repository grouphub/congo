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

# ==============
# Attachment One
# ==============

title = 'Sample Attachment'
description = 'An attachment for a group.'
name = ThirtySix.generate
tempfile = File.open("#{Rails.root}/spec/data/sample-attachment.png")
content_type = 'image/png'
url = S3.public_url(name)

if Rails.env.development?
  upload_to_fakes3(name, tempfile, content_type)
elsif Rails.env.production?
  S3.store(name, tempfile, content_type)
end

group = Group.where(name: 'My Group').first

Attachment.create! \
  account_id: group.account_id,
  group_id: group.id,
  title: title,
  filename: name,
  description: description,
  content_type: content_type,
  url: url

# ==============
# Attachment Two
# ==============

title = 'Sample Attachment'
description = 'An attachment for a benefit plan.'
name = ThirtySix.generate
tempfile = File.open("#{Rails.root}/spec/data/sample-attachment-2.png")
content_type = 'image/png'
url = S3.public_url(name)

if Rails.env.development?
  upload_to_fakes3(name, tempfile, content_type)
elsif Rails.env.production?
  S3.store(name, tempfile, content_type)
end

group = Group.where(name: 'My Group').first

Attachment.create! \
  account_id: group.account_id,
  benefit_plan_id: BenefitPlan.where(name: 'Best Health Insurance PPO').first.id,
  title: title,
  filename: name,
  description: description,
  content_type: content_type,
  url: url

