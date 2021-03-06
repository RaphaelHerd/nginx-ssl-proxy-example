# Introduction
This repositoy is used as demo for configuring serveral nginx servers used as transparent SSL proxy with client certification verification enabled.

The overall goal is to use a secure ssl connection between two parties without their knowledge. The idea is to use a transparent ssl proxy that handels the ssl staff. This solution can be used if you have existing components which are using RESTful APIs and you need a secure and authenticated connection between them.

All certs are self signed and therefore for developement only. I added a set of certs to the repository for simple test purposes. Please generate new certs if you are develope a more enhanced solution.

It's also possible to combine a official signed x509 (HTTPS) certificate and use an additional self-signed client certificate for authentication.

# Scenario
**"Client/Broweser"** --http/s without client cert.--> **"client-proxy"** --https **with** client cert.--> **"server-proxy"** --http/s without client cert.--> **"target/nginx-backend"**

# Step 1 - Generate Certificates for SSL
Generate the demo certs by using the ***create-certs.sh*** shell scrip. It will create the necessary certs for the server and the client and directly copy them into the corresponding directories. Have a look into the script to get a better understanding how the cert stuff is working and which cert you need in which component.

# Step 2 - Start and Test Client and Server
1. Start server in a seperate terminal by using ***start-compose.sh***. It will start a docker compose script in interactive (it) mode that you are able to see the server logs in the console.

2. Use the curl client to test the connection and the request forwarding including certification validation.
Use ***curl http://localhost:8081***.

# Step 3 - Validate SSL
To make sure SSL is encorced under any cirsumstances, use curl and try directly accessing the server-proxy. To do that, change into the directory **client-proxy/nginx/certs** and use the following command:

```
curl -v -s -k --key client.key --cert client.crt https://localhost
```

The result shows you the body as well as the meta and header informations. Make sure SSL is enabled.

# Step 4 - How it works:
If you are curling (browsing) to the client-proxy (simple nginx), the client proxy forwards your request to an upstream proxy. This upstream proxy is an nginx proxy with SSL and client certification enabled. Therefore, the client-proxy injects the necessary client certificates that the server-proxy is able to validate and pass the request. The server-proxy then can forward the request to an upstream of choice. In the current example we are using a third nginx (nginx-backend) with simple HTTP capabilities. The nginx-backend is a default nginx without any additional configurations. 
