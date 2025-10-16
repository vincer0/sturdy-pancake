#!/bin/bash

if [ ! -f /var/certs/cert.pem ]; then
    mkdir -p /var/certs;
    openssl req \
    -new \
    -newkey ec \
    -pkeyopt ec_paramgen_curve:prime256v1 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=DE/ST=NRW/L=Duesseldorf/O=Bam/CN=default" \
    -keyout "/var/certs/privkey.pem" \
    -out "/var/certs/cert.pem"
fi

nginx
