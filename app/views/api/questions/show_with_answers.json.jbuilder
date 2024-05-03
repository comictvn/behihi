
json.status 200
json.question do
  json.id @question.id
  json.content @question.content
  json.illustration url_for(@question.illustration) if @question.illustration.attached?
end
json.options @options do |option|
  json.id option.id
  json.content option.content
end
