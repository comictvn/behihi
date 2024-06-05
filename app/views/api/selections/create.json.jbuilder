
if @error_object.present?
  json.error_object @error_object
else
  json.status @status
  json.message @message
end
