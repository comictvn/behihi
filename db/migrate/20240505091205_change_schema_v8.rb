class ChangeSchemaV8 < ActiveRecord::Migration[6.0]
  def change
    create_table :achievements do |t|
      t.string :name

      t.timestamps null: false
    end

    add_column :test_progresses, :score, :float

    add_column :test_progresses, :completed_at, :datetime

    add_reference :answers, :test_progress, foreign_key: true

    add_reference :test_progresses, :user, foreign_key: true

    add_reference :achievements, :user, foreign_key: true
  end
end
