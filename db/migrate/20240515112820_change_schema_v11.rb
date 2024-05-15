class ChangeSchemaV11 < ActiveRecord::Migration[6.0]
  def change
    create_table :his do |t|
      t.timestamps null: false
    end
  end
end
