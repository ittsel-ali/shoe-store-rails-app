
![Blank diagram (1)](https://github.com/user-attachments/assets/a1f60a8e-e67b-4651-a3f0-a768f49b438f)


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
- Docker
- Kubectl
- Helm
- Kafka

If you want to setup everything on Local then, you would also require following:
- Redis
- Postgres

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/ittsel-ali/shoe-store-rails-app.git
   cd shoe-store-rails-app

2. **Setup K8 (MAC)**
   ```bash
   brew install kubectl

By default, Docker Desktop sets up kubectl to use the local Kubernetes cluster. You can test it by running: `kubectl get nodes`, if it does not show anything, try enabling Kubernetes from Docker Desktop application installed on your system, attachment for reference below:
     <img width="1264" alt="Screenshot 2024-08-27 at 2 17 05 PM" src="https://github.com/user-attachments/assets/cfc40b05-6930-4ef8-b645-432f7697de44">

3. **Setup Helm (MAC)**
   ```bash
   brew install helm

4. **Setup Kafka (MAC)**
   ```bash
   brew install zookeeper
   brew install kafka
    
   brew services start zookeeper
   brew services start kafka
   
5. **Setup Ngrok (MAC)**

   Run in seperate terminal! This is required to allow k8 to listen to the feed send by the shoe-store inventory.rb, otherwise k8 will cause conflicts with localhost
   ```bash
   brew install ngrok

   ngrok tcp 9092

7. **Update websocket listener K8 values**

   Replace `WEBSOCKET_URL` value with the ip provided by Ngrok. You can update using cmd below: 
   ```bash
   nano websocket-listener-deployment.yml
   
8. **Deploy Application to K8**
   Run cmds below from rails app folder!
   ```bash
   helm repo add bitnami https://charts.bitnami.com/bitnami
   helm repo update

   helm install my-postgres-ha bitnami/postgresql-ha -f postgres-deployment.yml

   kubectl apply -f redis-deployment.yml
   kubectl apply -f db-migrate-job.yml
   kubectl apply -f sidekiq-deployment.yml 
   kubectl apply -f websocket-listener-deployment.yml
   kubectl apply -f rails-app-deployment.yml 

Note: The docker image is already pushed to public registery `ittselali/my-rails-app:latest`, so you would not need to build it locally, kubectl will automatically pick the correct image as a part of deployment. 

After running the commands above make sure you can see all the K8 pods running, the db migration job will fail initially but will automatically succeed in less than a minute. You can check with cmd `kubectl get pods`. Here is the reference image of pods

<img width="674" alt="Screenshot 2024-08-27 at 2 51 17 PM" src="https://github.com/user-attachments/assets/48fff141-0cc8-44cf-a974-be3780b05769">

#### Pods List Details:
- Three DB pods, two will be read replicas and one for primary DB. 
- A DB migrate job
- Two Rails apps
- Two SideKiq worker pods
- One Redis server
- One Websocket Listener

Also, you can check the K8 services running, below is the image:
 <img width="865" alt="Screenshot 2024-08-27 at 2 55 13 PM" src="https://github.com/user-attachments/assets/49dcd438-79f3-4c17-8dac-4b7d29534c7f">

#### Services List Details:
 - DB load balancer for read replicas connection
 - DB service for master DB connection
 - App load balancer for rails apps
 - redis service


### Running the Application
Access running application on browser at http://localhost
