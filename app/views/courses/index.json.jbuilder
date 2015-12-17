json.array!(@courses) do |course|
  json.extract! course, :id, :name, :description, :active_date, :close_date
  json.url course_url(course, format: :json)
end
