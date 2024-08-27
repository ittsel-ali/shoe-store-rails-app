class CheckInventoryStatus
  include Sidekiq::Job

  def perform
    Inventory.where(inventory: 0).find_each do |inventory|
      suggested_shipping_store = Inventory.where("inventory > 0").distinct.limit(3) || []

      stores_arr = suggested_shipping_store.map{ |item| item.store }

      ActionCable.server.broadcast "inventory_channel", {
                                   type: "zero_inventory",
                                   message: "Inventory for #{inventory.model} in store #{inventory.store} is now 0. Suggested stores for shipping: #{stores_arr.join(', ')}"
                                  }
    end
  end
end