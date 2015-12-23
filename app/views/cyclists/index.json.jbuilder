json.array!(@cyclists) do |cyclist|
  json.extract! cyclist, :id, :name, :description, :gender, :created_at
  json.url cyclist_url(cyclist, format: :json)
end
