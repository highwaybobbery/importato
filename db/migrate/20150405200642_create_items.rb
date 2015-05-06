class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :description
      t.integer :price
      t.belongs_to :merchant, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
