class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.belongs_to :customer, index: true, foreign_key: true
      t.belongs_to :merchant, index: true, foreign_key: true
      t.belongs_to :item, index: true, foreign_key: true
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
