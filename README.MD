# Introduction
This repositoy is used as demo for configuring serveral nginx servers used as transparent SSL proxy with client certification verification enabled.

The overall goal is to use a secure ssl connection between two parties without their knowledge. The idea is to use a transparent ssl proxy that handels the ssl staff. This solution can be used if you have existing components which are using RESTful APIs and you need a secure and authenticated connection between them.

All certs are self signed and therefore for developement only. I added a set of certs to the repository for simple test purposes. Please generate new certs if you are develope a more enhanced solution.

It's also possible to combine a official signed x509 (HTTPS) certificate and use an additional self-signed client certificate for authentication.

# Scenario
"Client/Broweser" --http/s without client cert.--> "client-proxy" --https with client cert.--> "server-proxy" --http/s without client cert.--> "target/nginx-backend"

# Step 1 - Generate Certificates for SSL
Generate the demo certs by using the ***create-certs.sh*** shell scrip. It will create the necessary certs for the server and the client.

# Step 2 - Copy Certs to  Server and Client
On the server side proxy we are only using 
- ca.crt
- server.crt
- server.key

Copy the denoted certs from ***certs*** to ***server-proxy/nginx/certs***.

On the client, we are only using 
- client.key
- client.crt

Copy the denoted certs from ***certs*** to ***client-proxy/nginx/certs***.

# Start and Test Client and Server
1. Start server in a seperate terminal by using ***start-compose.sh***. It will start a docker compose script in interactive (it) mode that you are able to see the server logs in the console.

2. Use the curl client to test the connection and the request forwarding including certification validation.
Use ***curl http://localhost:8081***.

# How it works:
If you are curling (browsing) to the client-proxy (simple nginx), the client proxy forwards your request to an upstream proxy. This upstream proxy is an nginx proxy with SSL and client certification enabled. Therefore, the client-proxy injects the necessary client certificates that the server-proxy is able to validate and pass the request. The server-proxy then can forward the request to an upstream of choice. In the current example we are using a third nginx (nginx-backend) with simple HTTP capabilities. The nginx-backend is a default nginx without any additional configurations. 
