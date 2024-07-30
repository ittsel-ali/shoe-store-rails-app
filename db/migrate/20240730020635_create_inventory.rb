class CreateInventory < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|

      t.string :model
      t.string :store
      t.integer :inventory
      t.timestamps
    end
  end
end
