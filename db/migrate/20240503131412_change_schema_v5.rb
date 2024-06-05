class ChangeSchemaV5 < ActiveRecord::Migration[6.0]
  def change
    add_column :options, :is_correct, :boolean
  end
end
