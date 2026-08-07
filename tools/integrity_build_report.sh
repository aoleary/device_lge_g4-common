#!/bin/bash

PRODUCT=${1:-h815}

OUT=out/target/product/$PRODUCT

echo "================================"
echo " LG G4 Play Integrity Report"
echo "================================"


echo
echo "Build properties"

grep -E \
"ro.build.fingerprint|ro.build.tags|ro.build.type|ro.debuggable|ro.product.device" \
$OUT/system/build.prop 2>/dev/null


echo
echo "Fingerprint locations"

grep -R "fingerprint" \
$OUT/system \
$OUT/vendor \
$OUT/product \
$OUT/system_ext \
2>/dev/null


echo
echo "CTS files"

find $OUT -name "*lg-g4-cts*"


echo
echo "test-keys"

grep -R "test-keys" $OUT/system >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "WARNING: test keys found"
else
    echo "OK"
fi


echo
echo "Report complete"
