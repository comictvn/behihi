class ChangeSchemaV10 < ActiveRecord::Migration[6.0]
  def change
    drop_table :new_tables
  end
end
