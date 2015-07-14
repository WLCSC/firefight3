json.array!(@consumables) do |consumable|
  json.extract! consumable, :id, :name, :short, :barcode
  json.url consumable_url(consumable, format: :json)
end
