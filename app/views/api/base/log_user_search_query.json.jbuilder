
json.status @status_code

if @error_message.present?
  json.error @error_message
else
  json.log do
    json.id @log.id
    json.search_query @log.search_query
    json.user_id @log.user_id
  end
end
