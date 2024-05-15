class ChangeSchemaV14 < ActiveRecord::Migration[6.0]
  def change
    create_table :error_notifications do |t|
      t.string :title

      t.text :description

      t.integer :priority, default: 0

      t.integer :status, default: 0

      t.timestamps null: false
    end

    add_reference :error_notifications, :user, foreign_key: true
  end
end
