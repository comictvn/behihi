class ChangeSchemaV6 < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :option, foreign_key: true
  end
end
