# ocsp.sh

Retrieve a OCSP response via curl for a TLS certificate bundle, to be used with nginx's `ssl_stapling_file` directive. The response is verified at the end of the script and the output of the verification is printed to stdout.

Usage

```
Usage: ocsp.sh fullchain.pem res.der [chain.pem]

Retrieve a OCSP response via curl for a TLS certificate bundle.
fullchain.pem is a bundle containing a cert and its signer cert.
chain.pem should contain signer certs and is used to verify the response.
```

Example

```console
$ ./ocsp.sh fullchain.pem res.der
Response verify OK
$ ./ocsp.sh fullchain.pem res.der chain.pem
Response verify OK
```

© [silverwind](https://github.com/silverwind), distributed under BSD licence.
