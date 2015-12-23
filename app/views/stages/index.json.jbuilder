json.array!(@stages) do |stage|
  json.extract! stage, :id, :race_id, :name, :active_date, :close_date
  json.url stage_url(stage, format: :json)
end
