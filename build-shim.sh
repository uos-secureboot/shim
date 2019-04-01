#!/bin/bash -xe

# From debian/rules
cert=
if [[ -e "endless-uefi-ca.der" ]]; then
  cert="endless-uefi-ca.der"
fi

dbx=
if [[ -e "endless-uefi-dbx.der" ]]; then
  dbx="endless-uefi-dbx.esl"
fi

distributor=endless
oslabel="EndlessOS"

COMMON_OPTIONS="\
 RELEASE=15 \
 COMMIT_ID=a4a1fbe728c9545fc5647129df0cf1593b953bec \
 MAKELEVEL=0 \
 EFI_PATH=/usr/lib \
 ENABLE_HTTPBOOT=true \
 ENABLE_SBSIGN=1 \
 VENDOR_CERT_FILE=${cert} \
 EFIDIR=${distributor} \
 VENDOR_DBX_FILE=${dbx} \
 OSLABEL=${oslabel} \
 FALLBACK_VERBOSE=1 \
 FALLBACK_VERBOSE_WAIT=3000000"

DEFAULT_DESTDIR=./destdir
if [[ ! -z $1 ]] ; then
  destdir="$1"
else
  echo "Usage: $0 <DESTDIR>"
  echo "DESTDIR not specified, installing to $DEFAULT_DESTDIR"
  destdir=$DEFAULT_DESTDIR
fi

rm -rf "${destdir}"
make clean
make ${COMMON_OPTIONS}
make install DESTDIR="${destdir}" ${COMMON_OPTIONS}
