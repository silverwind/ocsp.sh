#!/bin/bash
set -euo pipefail

USAGE="Retrieve a OCSP response via curl for a TLS certificate bundle.

Usage:
  "$(basename "$0")" fullchain.pem ocsp.der [chain.pem]

Parameters
  fullchain.pem  A TLS certificate bundle containing a cert and its signer cert
  ocsp.der       The output file of the ocsp response
  chain.pem      Additional signer certs used during response verification"

if [ $# -ne 2 ] && [ $# -ne 3 ]; then
  echo "${USAGE}"
  exit 1
fi

# create a temp dir
TMP="$(mktemp -d)"

# split certs
awk '{print > "'"${TMP}/cert"'" (1+n) ".pem"} /-----END CERTIFICATE-----/ {n++}' < "$1"

# set cert and issuer, get ocsp uri
CERT="${TMP}/cert1.pem"
ISSUER="${TMP}/cert2.pem"
REQ="${TMP}/req"
URI="$(openssl x509 -in "${CERT}" -noout -ocsp_uri)"

# create the ocsp request and base64-urlencode it
openssl ocsp -noverify -no_cert_verify -no_nonce -reqout "${REQ}" -issuer "${ISSUER}" -cert "${CERT}" -text 1>/dev/null
REQ="$(python -c "exec(\"try:\n from urllib import quote_plus\nexcept ImportError:\n from urllib.parse import quote_plus\nimport sys\nprint(quote_plus(sys.argv[1]))\")" "$(openssl enc -a -in "${REQ}" | tr -d "\n")")"

# retrieve response and save it
curl -s "${URI}/${REQ}" -o "$2"

if [ $# -eq 2 ]; then
  openssl ocsp -respin "$2" -issuer "${ISSUER}"
else
  openssl ocsp -respin "$2" -issuer "${ISSUER}" -verify_other "$3"
fi

# clean up
rm -rf "${TMP}"
