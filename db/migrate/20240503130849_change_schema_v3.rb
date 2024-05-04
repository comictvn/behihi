class ChangeSchemaV3 < ActiveRecord::Migration[6.0]
  def change
    create_table :faq_interactions do |t|
      t.integer :interaction_type, default: 0

      t.timestamps null: false
    end

    add_column :faq_searches, :search_query, :string

    add_reference :faq_interactions, :question, foreign_key: true

    add_reference :faq_interactions, :user, foreign_key: true

    add_reference :faq_searches, :user, foreign_key: true
  end
end
