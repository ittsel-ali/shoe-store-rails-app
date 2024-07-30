# InventoryApp

InventoryApp is a Rails application that listens to a WebSocket service, processes incoming messages, saves them to the database, and broadcasts them to the client in real-time using Action Cable.

## Table of Contents

- Getting Started
- Prerequisites
- Installation
- Running the Application

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Ruby ruby 3.3.0 (2023-12-25 revision 5124f9ac75) [arm64-darwin23]
- Rails Rails 7.1.3.4

### Installation

1. **Clone the repository**

   ```bash
   git clone git@github.com:username/inventory_app.git
   cd inventory_app

2. **Install Gems**

   ```bash
   bundle install

3. **Setup Database**

   ```bash
   rails db:create
   rails db:migratep

4. **Run Inventory Service on port (8080) by following the instructions here: https://github.com/mathieugagne/shoe-store**


4. **Run Server**

   ```bash
   rails s

5. **Navigate to http://localhost:3000 to see the application running.**

WebSocket Listener
The application includes a WebSocket listener that runs as a background service. This service listens to a WebSocket server, processes incoming messages, and broadcasts them to the client in real-time.
