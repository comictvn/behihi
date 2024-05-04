
json.status @status
json.feedback do
  json.isCorrect @feedback[:isCorrect]
  json.message @feedback[:message]
  json.explanation @feedback[:explanation]
end
json.nextEnabled @next_enabled
