class ChangeSchemaV1 < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username

      t.timestamps null: false
    end

    create_table :questions do |t|
      t.text :content

      t.timestamps null: false
    end
  end
end
