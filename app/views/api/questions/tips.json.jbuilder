json.status 200
json.question do
  json.id @question.id
  json.content @question.content
  json.illustration @question.illustration.url if @question.illustration.attached?
  json.tips @question.options.where(is_correct: true).pluck(:content)
end