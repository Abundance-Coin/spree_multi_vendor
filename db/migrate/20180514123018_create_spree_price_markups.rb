class CreateSpreePriceMarkups < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_price_markups do |t|
      t.decimal :amount, precision: 8, scale: 5
      t.string :name
      t.references :vendor

      t.timestamps null: false
    end
  end
end
