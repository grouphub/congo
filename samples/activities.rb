#!/usr/bin/env bundle exec rails runner

require 'pokitdok'

pokitdok = PokitDok::PokitDok.new \
  Rails.application.config.pokitdok.client_id,
  Rails.application.config.pokitdok.client_secret

data = {
  activity_id: '54fd576b9dce610056ff6d85'
}

File.open("#{File.dirname __FILE__}/activities.json") do |f|
  response = pokitdok.activities(data)
  f.puts JSON.pretty_generate(response)
end

