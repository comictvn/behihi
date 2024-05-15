class ChangeSchemaV13 < ActiveRecord::Migration[6.0]
  def change
    rename_table :newaaas, :newaaas1111s
    change_table_comment :newaaas1111s, from: '', to: 'fff'
  end
end
