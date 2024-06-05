
json.status 200
json.next_question_id @next_question.id
json.current_question_number @test_progress.current_question_number
json.total_questions @test_progress.total_questions
json.progress_percentage (@test_progress.current_question_number.to_f / @test_progress.total_questions.to_f * 100).round(2)
json.message "You have successfully navigated to the next question."
