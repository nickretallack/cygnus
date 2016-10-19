json.array!(@requests) do |request|
  json.extract! request, :id, :body, :user_id, :breed, :title, :end_date, :max_price
  json.url request_url(request, format: :json)
end
