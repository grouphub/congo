pokitdok = PokitDok::PokitDok.new \
  Rails.application.config.pokitdok.client_id,
  Rails.application.config.pokitdok.client_secret

data = JSON.parse(File.read("#{Rails.root}/spec/data/application-pokitdok.json"))

data['async'] = true
data['callback_url'] = sprintf \
  '%s/api/internal/accounts/%s/roles/%s/applications/%s/callback.json',
  Rails.application.config.pokitdok.callback_host,
  'first_account',
  'customer',
  '1'

response = pokitdok.enrollment(data)

binding.pry
