# ocsp.sh

Retrieve a OCSP response via curl for a TLS certificate bundle, to be used with nginx's `ssl_stapling_file` directive. The response is verified at the end of the script and the output of the verification is printed to stdout.

Usage

```
Usage: ocsp.sh certs.pem res.der
```

Example

```console
$ ./ocsp.sh bundle.pem res.der
Response verify OK
```

© [silverwind](https://github.com/silverwind), distributed under BSD licence.
