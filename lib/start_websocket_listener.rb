require './config/environment'
require './lib/services/inventory_listener_service'

InventoryListenerService.new(ENV['WEBSOCKET_URL']).run