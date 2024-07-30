class Inventory < ApplicationRecord
  validates :store, presence: true
  validates :model, presence: true
  validates :inventory, presence: true

  def self.create_or_update_by_store_and_model(store, model, inventory)
    record = find_or_initialize_by(store: store, model: model)
    record.inventory = inventory
    record.save!
    record
  end
end
