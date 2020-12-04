# OpenSSL Docker Image on Alpine 3.12
OpenSSL 1.1.1g-r0 docker image based on alpine 3.12. Refers to Dockerfile
## Pull Image
```bash
docker pull tonkon/openssl:latest
```
## Tags
* latest
* 1.1.1g-alpine
## Examples

### Create a Certificate in Local Directory
Local directory **target** will be mounted to container. **demo.key** and **demo.crt** will be generated in local target folder.
```bash
docker run --rm \
  --mount type=bind,source="$(pwd)"/target,target=/cert \
  tonkon/openssl sh -c \
  'openssl req -x509 -sha256 -newkey rsa:2048 -keyout /cert/demo.key -out /cert/demo.crt -nodes -subj "/CN=demo"'

```

### Create a Certificate in Volume
A volume named **vol-cert** will be first created and then mounted to container. **demo.key** and **demo.crt** will be generated inside volume.

```bash
docker volume create vol-cert

docker run --rm \
  --mount type=volume,source=vol-cert,target=/cert \
  tonkon/openssl sh -c \
  'openssl req -x509 -sha256 -newkey rsa:2048 -keyout /cert/demo.key -out /cert/demo.crt -nodes -subj "/CN=demo"'

```
Afterward, the volume can be used in another container.
```bash
docker run --rm -d --name nginx -p 80:80 \
  --mount type=volume,source=vol-cert,target=/etc/nginx/ssl,readonly \
  nginx
docker exec nginx ls /etc/nginx/ssl
```

### Create a Certificate Interactively
It also can be interactively create certificate inside container.
```bash
docker run -it tonkon/openssl sh
```

## OpenSSL Examples

### Certificate with Subject
```bash
openssl req -x509 -sha256 -newkey rsa:2048 -keyout demo.key -out demo.crt -days 365 -nodes \
  -subj "/CN=www.demo.com" 
```
### Certificate with Subject Alternative Name

```bash
openssl req -x509 -sha256 -newkey rsa:2048 -keyout demo.key -out demo.crt -days 365 -nodes \
  -subj "/CN=www.demo.com" \
  -addext "subjectAltName=DNS:www.demo.com,DNS:localhost,DNS:127.0.0.1"
```

### Export pem to pfx
```bash
cat demo.crt > demo.pem
cat demo.key >> demo.pem
openssl pkcs12 -export -in demo.pem -out demo.pfx -passout 'pass:<password of demo.pfx>'
```

### Export pfx to pem
```bash
openssl pkcs12 -in demo.pfx -passin 'pass:<password of demo.pfx>' -out demo.pem -nodes
```
