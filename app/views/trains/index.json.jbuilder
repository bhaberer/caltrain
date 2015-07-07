json.array!(@trains) do |train|
  json.extract! train, :id, :number, :type
  json.url train_url(train, format: :json)
end
