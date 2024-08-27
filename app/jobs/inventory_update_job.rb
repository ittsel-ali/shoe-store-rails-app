class InventoryUpdateJob
  include Sidekiq::Job

# Exponential Backoff needed
  
  def perform(batch)
    sorted_batch = batch.group_by { |data| [data['store'], data['model']] }
                                 .map { |_, group| group.max_by { |data| data['update_sequence'] } }
    begin
      # Run query in master DB for write
      ActiveRecord::Base.connected_to(role: :writing) do
 
        # Use a single transaction to update all records in bulk
        ActiveRecord::Base.transaction do
          # Optionally use an advisory lock to serialize access to certain resources
          advisory_lock_key = sorted_batch.map { |data| "#{data['store']}_#{data['model']}".hash }.sum

      		# Ensure the advisory lock key is within the PostgreSQL 32-bit signed integer range
      		advisory_lock_key = advisory_lock_key % (2**31 - 1)

      		# If the result is still out of bounds, adjust it
      		advisory_lock_key = rand(900)

          ActiveRecord::Base.connection.execute("SELECT pg_advisory_lock(#{advisory_lock_key});")

          # Bulk update using a single SQL statement if possible, or iterate over the sorted batch
           values = sorted_batch.map do |data|
      		    "('#{data['store']}', '#{data['model']}', #{data['inventory']}, #{data['update_sequence']}, NOW(), NOW())"
      		  end.join(", ")

          sql = <<-SQL
      		  INSERT INTO inventories (store, model, inventory, update_sequence, created_at, updated_at)
      		  VALUES #{values}
      		  ON CONFLICT (store, model)
      		  DO UPDATE SET
      		    inventory = EXCLUDED.inventory,
      		    update_sequence = EXCLUDED.update_sequence,
      		    updated_at = NOW()
      		  WHERE EXCLUDED.update_sequence > inventories.update_sequence;
      		SQL

          ActiveRecord::Base.connection.execute(sql)

          # Release the advisory lock
          ActiveRecord::Base.connection.execute("SELECT pg_advisory_unlock(#{advisory_lock_key});")
        end
      end
    rescue ActiveRecord::Deadlocked
      # Retry the transaction if a deadlock occurs
      retry
    rescue ActiveRecord::StaleObjectError
      # Retry Handle the conflict for optimistic lock exception
      retry
    end
  end
end
