import consumer from "channels/consumer"

consumer.subscriptions.create("InventoryChannel", {
  connected() {
    console.log("Connected to the Inventory channel")
  },

  disconnected() {
    console.log("Disconnected from the Inventory channel")
  },

  received(data) {
    console.log("Data received:", data);


    if (data.type === "inventory_update") {
      const items = data.message;
      items.forEach(item => updateInventoryTable(item));
    } else if (data.type === "zero_inventory") {
      addZeroInventoryAlert(data.message);
    } else {
      console.log("Unknown type:", data.type);
    }
  }
});

function updateInventoryTable(item) {
    // Generate a unique ID for each row based on store and model for easy DOM element identification
    let rowId = `row-${item.store.replace(/\s+/g, '')}-${item.model.replace(/\s+/g, '')}`;
    let row = document.getElementById(rowId);

    if (!row) {
        // Create a new row if it doesn't exist
        row = tableBody.insertRow(-1); // -1 to append at the end of the table
        row.id = rowId;
        row.insertCell(0).textContent = item.store;  // Store cell
        row.insertCell(1).textContent = item.model;  // Model cell
        row.insertCell(2).textContent = item.inventory;  // Inventory cell
        console.log(`Added new row for ${item.store}, ${item.model}`);
    } else {
        // Update the existing row with new inventory data
        row.cells[2].textContent = item.inventory;
        console.log(`Updated inventory for ${item.store}, ${item.model}: ${item.inventory}`);
    }
}

function addZeroInventoryAlert(message) {
    let alertItem = document.createElement('li');
    alertItem.textContent = message;
    alertsList.appendChild(alertItem);
}