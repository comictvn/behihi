
json.status 200
json.is_correct @answer.is_correct
json.feedback @answer.is_correct ? "Your answer is correct." : "Your answer is incorrect."
