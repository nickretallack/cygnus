json.array!(@submissions) do |submission|
  json.extract! submission, :id, :title, :adult, :file_id, :pool_id
  json.url submission_url(submission, format: :json)
end
