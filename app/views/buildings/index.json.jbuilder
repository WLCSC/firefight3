json.array!(@buildings) do |building|
  json.extract! building, :id, :name, :short, :storeroom
  json.url building_url(building, format: :json)
end
