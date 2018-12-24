#!/bin/bash -xe

if [[ ! -z $1 ]] ; then
  ESPDIR="$1"
else
  echo "Usage: $0 <ESPDIR>"
  exit 1
fi

EFIDIR=$ESPDIR/EFI
DEFAULT_DIR=$EFIDIR/BOOT
ENDLESS_DIR=$EFIDIR/endless
default_shim=$DEFAULT_DIR/BOOTX64.EFI
endless_shim=$ENDLESS_DIR/shimx64.efi
fallback=$DEFAULT_DIR/fbx64.efi
mokmanager=$DEFAULT_DIR/mmx64.efi

# Generate key and certificate
if [[ ! -e test-key.rsa || ! -e test-cert.pem ]]; then
  echo "Generating test key and certificates"
  openssl genrsa -out test-key.rsa 2048
  openssl req -new -x509 -sha256 -subj '/CN=test-key' -key test-key.rsa -out test-cert.pem
  openssl x509 -in test-cert.pem -inform PEM -out test-cert.der -outform DER
fi

# Sign shim
echo "Signing $default_shim"
sbsign --key test-key.rsa --cert test-cert.pem --output $default_shim $endless_shim
pesign -S -i $default_shim
cp $default_shim $endless_shim

# Sign fallback
echo "Signing $fallback"
pesign -r -u 0 -i $fallback -o $fallback.unsigned
sbsign --key test-key.rsa --cert test-cert.pem --output $fallback $fallback.unsigned
pesign -S -i $fallback
rm -f $fallback.unsigned

# Sign MokManager
echo "Signing $mokmanager"
pesign -r -u 0 -i $mokmanager -o $mokmanager.unsigned
sbsign --key test-key.rsa --cert test-cert.pem --output $mokmanager $mokmanager.unsigned
pesign -S -i $mokmanager
rm -f $mokmanager.unsigned
