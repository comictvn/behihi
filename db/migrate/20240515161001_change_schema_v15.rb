class ChangeSchemaV15 < ActiveRecord::Migration[6.0]
  def change
    create_table :social_shares do |t|
      t.string :platform

      t.text :message

      t.timestamps null: false
    end

    add_reference :social_shares, :achievement, foreign_key: true

    add_reference :social_shares, :user, foreign_key: true
  end
end
