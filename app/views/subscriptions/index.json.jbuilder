json.array!(@subscriptions) do |subscription|
  json.extract! subscription, :id, :user_sid, :subscribable_id, :subscribable_type
  json.url subscription_url(subscription, format: :json)
end
