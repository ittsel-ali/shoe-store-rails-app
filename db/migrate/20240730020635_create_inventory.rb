class CreateInventory < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|
      t.string :store, null: false
      t.string :model, null: false
      t.integer :inventory, default: 0, null: false
      t.bigint :update_sequence, default: 0, null: false
      t.integer :lock_version, default: 0, null: false  # For optimistic locking

      t.timestamps
    end

    # Add a composite primary key on store and model
    add_index :inventories, [:store, :model], unique: true
  end
end
