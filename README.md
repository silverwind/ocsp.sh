# ocsp.sh

Shell script to retrieve a OCSP response for a TLS certificate bundle via `curl`.

The resulting file can for example be used with nginx's `ssl_stapling_file` directive. This is useful for retrieving OCSP responses via a proxy server. The response is verified at the end of the script and the output of the verification is printed to stdout.

## Usage

```
Usage: ocsp.sh fullchain.pem ocsp.der [chain.pem]

Retrieve a OCSP response via curl for a TLS certificate bundle.

Parameters
  fullchain.pem     A TLS certificate bundle containing a cert and its signer cert
  ocsp.der          The output file of the ocsp response
  chain.pem         Additional signer certs used during response verification
```

## Example

```console
$ ./ocsp.sh fullchain.pem res.der
Response verify OK
$ ./ocsp.sh fullchain.pem res.der chain.pem
Response verify OK
```

© [silverwind](https://github.com/silverwind), distributed under BSD licence.
