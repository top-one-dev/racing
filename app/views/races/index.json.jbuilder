json.array!(@races) do |race|
  json.extract! race, :id, :title, :describe, :start, :end
  json.url race_url(race, format: :json)
end
