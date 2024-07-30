import consumer from "channels/consumer"

consumer.subscriptions.create("InventoryChannel", {
  connected() {
    console.log("Connected to the Inventory channel")
  },

  disconnected() {
    console.log("Disconnected from the Inventory channel")
  },

  received(data) {
    console.log("Data received:", data)
    var storeIndex = options.xaxis.categories.indexOf(data.store);
    if (storeIndex === -1) {
      // If store doesn't exist, add it
      options.xaxis.categories.push(data.store);
      storeIndex = options.xaxis.categories.length - 1;
      
    }

    // Find if model already exists in the series
    var modelSeries = options.series.find(serie => serie.name === data.model);
    if (!modelSeries) {
      // If model doesn't exist in the series, add it
      modelSeries = { name: data.model, data: new Array(options.xaxis.categories.length).fill(0) };
      options.series.push(modelSeries);
    }

    // Update the inventory data for the specific store and model
    modelSeries.data[storeIndex] = data.inventory;

    chart.updateOptions(options);
  }
});
