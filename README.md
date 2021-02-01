# CFSSL HOWTO
https://github.com/cloudflare/cfssl

## Generate Fake Root CA
```bash
cfssl genkey -initca config/rootCA.json | cfssljson -bare generated/rootCA
```

## Generate Fake Intermediate Root CA
```bash
cfssl gencert -ca=rootCA.pem -ca-key=generated/rootCA-key.pem -config=config/cfssl.json -profile=intermediate_ca config/intermediateCA.json | cfssljson -bare generated/intermediateCA
```

## Generate client & server certificates
```bash
# server certificate signed by Fake Intermediate CA
cfssl gencert -ca=generated/intermediateCA.pem -ca-key=generated/intermediateCA-key.pem -config=config/cfssl.json -profile=server config/server.json | cfssljson -bare generated/server

# client certificate signed by Fake Intermediate CA
cfssl gencert -ca=generated/intermediateCA.pem -ca-key=generated/intermediateCA-key.pem -config=config/cfssl.json -profile=client config/client.json | cfssljson -bare generated/client
```

## Certificate SHA-256 fingerprint
```bash
# will return in aa:bb:xx format
openssl x509 -noout -fingerprint -sha256 -in generated/client.pem
# will return in aabbxx format
openssl x509 -in generated/client.pem -outform der | sha256sum
```

## Certificate serial
```bash
# will return in aa:bb:xx format
openssl x509 -noout -serial -in generated/client.pem | cut -d'=' -f2 | sed 's/../&:/g;s/:$//'
# will return in aabbxx format
openssl x509 -noout -serial -in generated/client.pem
```
