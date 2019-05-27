class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :price
      t.string :genre
      t.string :comments
      t.integer :stocks
      t.integer :count

      t.timestamps
    end
  end
end
