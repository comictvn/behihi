class ChangeSchemaV16 < ActiveRecord::Migration[6.0]
  def change
    create_table :reactions do |t|
      t.timestamps null: false
    end
  end
end
