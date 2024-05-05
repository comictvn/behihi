
json.status 200
json.question do
  json.id @question.id
  json.content @question.content
  json.illustration @question.illustration.url if @question.illustration.present?
end
json.options @options do |option|
  json.id option.id
  json.content option.content
end
