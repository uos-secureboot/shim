#!/bin/bash -xe

DESTDIR=./destdir
ESPDIR=$DESTDIR/boot/efi

# Build and sign
./build-shim.sh $DESTDIR

echo -e "\n---------------------------- SIGNING ----------------------------\n"
./gen-keys-and-sign-shim.sh $ESPDIR

echo -e "\n---------------------------- PACKING ----------------------------\n"
./build-dist-tarballs.sh $ESPDIR

echo -e "\n----------------------------- DONE! -----------------------------\n"
