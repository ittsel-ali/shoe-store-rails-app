require 'kafka'
require 'json'

class InventoryListenerService
  BATCH_SIZE = 15 # Total Size of batch at which job is executed

  def initialize(broker)
    @kafka = Kafka.new([broker])
    @topic = "inventory_updates"
    @batch = []
  end

  def run
    consumer = @kafka.consumer(group_id: "inventory_listener")
    consumer.subscribe(@topic)

    loop do
      consumer.each_message(automatically_mark_as_processed: false) do |message|
        handle_message(message)
        
        puts "Consumed Message: #{message.value}"

        # Periodically process the batch
        if @batch.size >= BATCH_SIZE
          process_batch
          consumer.commit_offsets
          puts "Acknowledged Batch Messages!!!"
        end
        consumer.mark_message_as_processed(message)
      end

      # Ensure batch processing after exiting the loop
      process_batch if @batch.any?
    end
end


  private

  def handle_message(message)
    data = JSON.parse(message.value)
    @batch << {
      'store' => data['store'],
      'model' => data['model'],
      'inventory' => data['inventory'],
      'update_sequence' => data['id']
    }
  end

  def process_batch
    InventoryUpdateJob.perform_async(@batch)
    ActionCable.server.broadcast "inventory_channel", {type: "inventory_update", message: @batch}
    @batch.clear
  end
end
