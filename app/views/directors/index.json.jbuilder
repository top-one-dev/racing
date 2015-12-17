json.array!(@directors) do |director|
  json.extract! director, :id
  json.url director_url(director, format: :json)
end
