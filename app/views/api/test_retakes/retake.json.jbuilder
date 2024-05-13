
# app/views/api/test_retakes/retake.json.jbuilder

# Assuming ResetTest is a service object that responds to .execute
# and has a method .success_message that returns the appropriate message.
json.status 200
json.message ResetTest.execute(user_id: user_id).success_message
