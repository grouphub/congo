def pokitdok
  @pokitdok ||= PokitDok::PokitDok.new \
    Rails.application.config.pokitdok.client_id,
    Rails.application.config.pokitdok.client_secret
end

