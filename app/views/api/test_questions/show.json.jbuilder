
json.status 200
json.question do
  json.id @question.id
  json.content @question.content
  json.illustration @question.illustration.attached? ? url_for(@question.illustration) : nil
end
json.layout do
  json.type "grid_or_two_option"
  json.options @question.options.map do |option|
    json.id option.id
    json.content option.content
  end
end
