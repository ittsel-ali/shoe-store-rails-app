require 'faye/websocket'
require 'eventmachine'
require 'json'

class InventoryListenerService
  def initialize(url)
    @url = url
  end

  def run
    EM.run {
      ws = Faye::WebSocket::Client.new(@url)

      ws.on :message do |event|
        data = JSON.parse(event.data)

        store = data['store']
        model = data['model']
        inventory = data['inventory']
        
        inventory = Inventory.create_or_update_by_store_and_model(store, model, inventory)
        
        ActionCable.server.broadcast "inventory_channel", inventory
      end
    }
  end
end
