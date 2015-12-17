json.array!(@rosters) do |roster|
  json.extract! roster, :id, :join_date
  json.url roster_url(roster, format: :json)
end
