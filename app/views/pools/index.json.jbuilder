json.array!(@pools) do |pool|
  json.extract! pool, :id, :title, :user_id
  json.url pool_url(pool, format: :json)
end
