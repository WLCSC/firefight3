json.array!(@models) do |model|
  json.extract! model, :id, :name, :manufacturer, :category, :consumable_id
  json.url model_url(model, format: :json)
end
