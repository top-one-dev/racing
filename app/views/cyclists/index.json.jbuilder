json.array!(@cyclists) do |cyclist|
  json.extract! cyclist, :id, :name, :gender, :ftp, :created_at
  json.url cyclist_url(cyclist, format: :json)
end
