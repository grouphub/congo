json.array!(@charges) do |charge|
  json.extract! charge, :id, :name
  json.url charge_url(charge, format: :json)
end
