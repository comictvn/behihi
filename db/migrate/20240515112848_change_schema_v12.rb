class ChangeSchemaV12 < ActiveRecord::Migration[6.0]
  def change
    create_table :newaaas do |t|
      t.timestamps null: false
    end

    drop_table :his
  end
end
