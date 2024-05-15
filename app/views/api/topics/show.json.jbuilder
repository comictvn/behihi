json.status 200
json.topic do
  json.id @topic.id
  json.title @topic.title
  json.content @topic.topic_details.first.content
end