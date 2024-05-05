
json.array! @topics do |topic|
  json.id topic['id']
  json.title topic['title']
end

json.total_count @total_count
json.current_page @current_page
json.limit_value @limit_value
