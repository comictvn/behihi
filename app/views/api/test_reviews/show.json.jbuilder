
json.status 200
json.answers @test_review.answers.map do |answer|
  json.question_id answer.question_id
  json.content answer.question.content
  json.selected_option answer.selected_option
  json.is_correct answer.is_correct
  json.submitted_at answer.submitted_at
end
