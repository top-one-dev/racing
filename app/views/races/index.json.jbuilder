json.array!(@races) do |race|
  json.extract! race, :id, :name, :description, :start_date, :end_date, :hashtag
  json.url race_url(race, format: :json)
end
