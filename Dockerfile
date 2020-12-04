FROM alpine:3.12
LABEL version="1.1.1g-r0"
LABEL description="Images with OpenSSL based on alpine"
RUN apk add --no-cache 'openssl=1.1.1g-r0'