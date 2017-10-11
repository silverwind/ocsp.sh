#/bin/sh

if [ $# -ne 2 ] && [ $# -ne 3 ]; then
  echo "Usage: $(basename $0) fullchain.pem res.der [chain.pem]"
  echo
  echo "Retrieve a OCSP response via curl for a TLS certificate bundle."
  echo "fullchain.pem is a bundle containing a cert and its signer cert".
  echo "chain.pem should contain signer certs and is used to verify the response."
  exit 1
fi

# create a temp dir
TMP=$(mktemp -d)

# split certs
awk '{print > "'"$TMP/cert"'" (1+n) ".pem"} /-----END CERTIFICATE-----/ {n++}' < "$1"

# set cert and issuer, get ocsp uri
CERT="$TMP/cert1.pem"
ISSUER="$TMP/cert2.pem"
REQ="$TMP/req"
URI=$(openssl x509 -in "$CERT" -noout -ocsp_uri)

# create the ocsp request and base64-urlencode it
openssl ocsp -noverify -no_cert_verify -no_nonce -reqout "$REQ" -issuer "$ISSUER" -cert "$CERT" -text 1>/dev/null
REQ=$(python -c "import sys, urllib; print urllib.quote_plus(sys.argv[1])" $(openssl enc -a -in "$REQ" | tr -d "\n"))

# retrieve response and save it
curl -s "$URI/$REQ" -o "$2"

if [ -z "$3" ]; then
  openssl ocsp -respin "$2" -issuer "$ISSUER"
else
  openssl ocsp -respin "$2" -issuer "$ISSUER" -verify_other "$3"
fi

# clean up
rm -rf "$TMP"
