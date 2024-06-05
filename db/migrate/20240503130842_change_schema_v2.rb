class ChangeSchemaV2 < ActiveRecord::Migration[6.0]
  def change
    create_table :options do |t|
      t.string :content

      t.timestamps null: false
    end

    create_table :faq_searches do |t|
      t.timestamps null: false
    end

    create_table :answers do |t|
      t.datetime :submitted_at

      t.string :selected_option

      t.timestamps null: false
    end

    add_reference :answers, :user, foreign_key: true

    add_reference :answers, :question, foreign_key: true

    add_reference :options, :question, foreign_key: true
  end
end
