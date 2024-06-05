class ChangeSchemaV4 < ActiveRecord::Migration[6.0]
  def change
    create_table :test_progresses do |t|
      t.integer :total_questions

      t.integer :current_question_number

      t.timestamps null: false
    end

    add_column :answers, :is_correct, :boolean
  end
end
