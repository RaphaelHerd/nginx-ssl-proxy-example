#! /usr/bin/env bash

echo 'create certs dir'
mkdir -p certs

echo 'Create the CA Key and Certificate for signing Client Certs'
openssl genrsa -out certs/ca.key 4096
openssl req -new -x509 -days 365 -key certs/ca.key -out certs/ca.crt -subj "/C=DE/ST=Nordrhein-Westfalen/L=Duesseldorf/O=test group/OU=testcomapny/CN=localhostCA"

echo 'Create the Server Key, CSR, and Certificate'
openssl genrsa -out certs/server.key 1024
openssl req -new -key certs/server.key -out certs/server.csr -subj "/C=DE/ST=Nordrhein-Westfalen/L=Duesseldorf/O=test group/OU=testcomapny/CN=server_proxy"

echo 'Were self signing our own server cert here. This is a no-no in production'
openssl x509 -req -days 365 -in certs/server.csr -CA certs/ca.crt -CAkey certs/ca.key -set_serial 01 -out certs/server.crt

echo 'Create the Client Key and CSR'
openssl genrsa -out certs/client.key 1024
openssl req -new -key certs/client.key -out certs/client.csr -subj "/C=DE/ST=Nordrhein-Westfalen/L=Duesseldorf/O=test group/OU=testcomapny/CN=server_proxy"

echo 'Sign the client certificate with our CA cert.  Unlike signing our own server cert, this is what we want to do.'
# Serial should be different from the server one, otherwise curl will return NSS error -8054
openssl x509 -req -days 365 -in certs/client.csr -CA certs/ca.crt -CAkey certs/ca.key -set_serial 02 -out certs/client.crt

echo 'Verify Server Certificate'
openssl verify -purpose sslserver -CAfile certs/ca.crt certs/server.crt

echo 'Verify Client Certificate'
openssl verify -purpose sslclient -CAfile certs/ca.crt certs/client.crt


echo 'create certs dir in server-proxy'
rm -R server-proxy/nginx/certs/
mkdir -p server-proxy/nginx/certs/

echo 'copy certs server-proxy dir'
cp certs/ca.crt server-proxy/nginx/certs/
cp certs/server.crt server-proxy/nginx/certs/
cp certs/server.key server-proxy/nginx/certs/

echo 'create certs dir in client-proxy'
rm -R client-proxy/nginx/certs/
mkdir -p client-proxy/nginx/certs/

echo 'copy certs client-proxy dir'
cp certs/ca.crt client-proxy/nginx/certs/
cp certs/client.crt client-proxy/nginx/certs/
cp certs/client.key client-proxy/nginx/certs/