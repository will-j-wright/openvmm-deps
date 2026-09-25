#!/bin/sh

# Apply the patch series for the kernel line selected by $LINUX_VERSION.
#
# Patches live in pkg/linux/<version>/patches/ and apply in filename order.
# Kernel lines without a patches directory are left untouched, so their
# source may stay mounted read-only.

set -e

if [ -z "$LINUX_VERSION" ]; then
    >&2 echo "LINUX_VERSION must be set (e.g. via sysroots/linux-<ver>/deps)"
    exit 1
fi

patch_dir="$PKGDIR/$LINUX_VERSION/patches"

if [ ! -d "$patch_dir" ]; then
    exit 0
fi

for patch_file in "$patch_dir"/*.patch; do
    [ -f "$patch_file" ] || continue
    echo "Applying $(basename "$patch_file")"
    patch -p1 --forward --batch --fuzz=0 <"$patch_file"
done
