# Introduction
This repositoy is used as demo for configuring an NGINX Server with http as well as https enabled.

All certs are self signed and therefore for developement only.

# Step 1 - Generate Certificates for SSL
Generate the demo certs by using the ***scripts/create-certs.sh*** shell scrip. It will create the necessary certs for the server and the client.

# Step 2 - Move Certs to Server and Client
On the server side we are only using 
- ca.crt
- server.crt
- server.key

Copy the denoted certs from ***scripts/certs*** to ***nginx-config/certs***.

On the client, we are only using 
- client.key
- client.crt

Copy the client certs from scripts/certs to client-config.

# Start and Test Client and Server
1. Start server in a seperate terminal by using ***start-nginx.sh***. It will start a docker container in interactive (it) mode that you are able to see the server logs in the console.

2. Use the curl client to test the connection and cert validation. Change directory to ***client-config***. Use

***curl -v -s -k --key client.key --cert client.crt https://localhost***

for testing the connection. View logs of client and server.
