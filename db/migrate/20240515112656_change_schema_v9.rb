class ChangeSchemaV9 < ActiveRecord::Migration[6.0]
  def change
    create_table :new_tables do |t|
      t.timestamps null: false
    end
  end
end
