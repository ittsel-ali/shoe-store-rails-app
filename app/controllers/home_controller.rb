class HomeController < ApplicationController
	def index
		ActiveRecord::Base.connected_to(role: :reading) do
		    @inventory = Inventory.all
			# For demo purpose only
			puts ActiveRecord::Base.connection_pool.db_config.inspect
		end
	end
end