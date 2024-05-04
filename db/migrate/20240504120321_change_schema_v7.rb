class ChangeSchemaV7 < ActiveRecord::Migration[6.0]
  def change
    create_table :topics do |t|
      t.string :title

      t.timestamps null: false
    end

    create_table :topic_details do |t|
      t.text :content

      t.timestamps null: false
    end

    add_reference :topics, :user, foreign_key: true

    add_reference :topic_details, :topic, foreign_key: true
  end
end
