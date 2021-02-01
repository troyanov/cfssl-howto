.PHONY: default
default: certs ;

.PHONY: clean
clean:
	rm -f generated/*

.PHONY: certs
certs: clean
certs: $(shell mkdir -p generated)
certs: generated/rootCA.pem generated/rootCA-key.pem
certs: generated/intermediateCA.pem generated/intermediateCA-key.pem
certs: generated/cacerts.pem
certs: generated/server.pem generated/server-key.pem
certs: generated/client.pem generated/client-key.pem

generated/rootCA.pem generated/rootCA-key.pem:
	cfssl genkey -initca config/rootCA.json | cfssljson -bare generated/rootCA

generated/intermediateCA.pem generated/intermediateCA-key.pem:
generated/intermediateCA.pem generated/intermediateCA-key.pem: generated/rootCA.pem generated/rootCA-key.pem
	cfssl genkey -initca config/intermediateCA.json | cfssljson -bare generated/intermediateCA

generated/cacerts.pem: generated/rootCA.pem generated/intermediateCA.pem
	cat generated/rootCA.pem generated/intermediateCA.pem > generated/cacerts.pem

generated/client.pem generated/client-key.pem:
generated/client.pem generated/client-key.pem: generated/intermediateCA.pem generated/intermediateCA-key.pem
	cfssl gencert -ca=generated/intermediateCA.pem \
		-ca-key=generated/intermediateCA-key.pem \
		-config=config/cfssl.json -profile=client config/client.json | cfssljson -bare generated/client

generated/server.pem generated/server-key.pem:
generated/server.pem generated/server-key.pem: generated/intermediateCA.pem generated/intermediateCA-key.pem
	cfssl gencert -ca=generated/intermediateCA.pem \
		-ca-key=generated/intermediateCA-key.pem \
		-config=config/cfssl.json -profile=server config/server.json | cfssljson -bare generated/server
