json.array!(@services) do |service|
  json.extract! service, :id, :name, :url, :description, :parent_id
  json.url service_url(service, format: :json)
end
