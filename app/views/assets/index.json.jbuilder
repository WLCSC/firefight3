json.array!(@assets) do |asset|
  json.extract! asset, :id, :tag, :vendor, :history, :serial, :purchase, :cost, :name
  json.url asset_url(asset, format: :json)
end
