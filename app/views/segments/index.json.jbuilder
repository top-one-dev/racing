json.array!(@segments) do |segment|
  json.extract! segment, :id, :strava_url, :description, :length
  json.url segment_url(segment, format: :json)
end
