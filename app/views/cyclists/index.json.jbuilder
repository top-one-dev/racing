json.array!(@cyclists) do |cyclist|
  json.extract! cyclist, :id, :name, :description, :gender, :join_date
  json.url cyclist_url(cyclist, format: :json)
end
