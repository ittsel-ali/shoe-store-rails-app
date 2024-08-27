# Rails.application.config.to_prepare do
#   if Rails.env.development? || Rails.env.production?
#     Thread.new do
#       InventoryListenerService.new('ws://localhost:8080/').run
#     end
#   end
# end