
json.status 200
json.options @options do |option|
  json.id option.id
  json.content option.content
end
