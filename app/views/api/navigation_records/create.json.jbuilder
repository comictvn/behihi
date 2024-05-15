json.set! :navigation_record do
  if @navigation_record.persisted?
    json.id @navigation_record.id
    json.user_id @navigation_record.user_id
    json.question_id @navigation_record.question_id
    json.navigation_choice @navigation_record.navigation_choice
    json.created_at @navigation_record.created_at
    json.updated_at @navigation_record.updated_at
  else
    json.errors @navigation_record.errors.full_messages
  end
end