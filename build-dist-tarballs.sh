#!/bin/bash -xe

if [[ ! -z $1 ]] ; then
  ESPDIR="$1"
else
  echo "Usage: $0 <ESPDIR>"
  exit 1
fi

cert=test-cert.der

EFIDIR=$ESPDIR/EFI
DEFAULT_DIR=$EFIDIR/BOOT
ENDLESS_DIR=$EFIDIR/endless
fallback=$DEFAULT_DIR/fbx64.efi

archive_prefix="shim-signed"
archive_extension="tar.xz"
archive_fixed="${archive_prefix}-fixed.${archive_extension}"
archive_removable="${archive_prefix}-removable.${archive_extension}"
TAR="tar --owner=root --group=root"

# Copy certificate to ESP
cp $cert $DEFAULT_DIR

# Create tarball for fixed disks
$TAR -C $ESPDIR -cvf ${archive_fixed} EFI

# Create tarball for removable disks
rm -v $fallback
rm -frv $ENDLESS_DIR
$TAR --owner=root --group=root -C $ESPDIR -cvf ${archive_removable} EFI

rm -frv $ESPDIR
