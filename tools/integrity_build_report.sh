#!/usr/bin/env bash
set -euo pipefail

OUT="${1:-}"

if [[ -z "$OUT" || ! -d "$OUT" ]]; then
    echo "Usage: $0 out/target/product/<product>" >&2
    exit 2
fi

echo "============================================================"
echo " LG G4 Integrity / Identity Build Report"
echo "============================================================"
echo "Output: $OUT"
echo

get_prop_from_file() {
    local file="$1"
    local key="$2"

    [[ -f "$file" ]] || return 1

    awk -F= -v k="$key" '
        $1 == k {
            sub(/^[^=]*=/, "")
            print
            exit
        }
    ' "$file"
}

print_value() {
    local label="$1"
    local value="$2"

    if [[ -n "$value" ]]; then
        printf '  %-16s %s\n' "$label" "$value"
    else
        printf '  %-16s <not found>\n' "$label"
    fi
}

print_partition_identity() {
    local partition="$1"
    local file="$2"
    local prefix="$3"

    echo "$partition"

    print_value "brand" \
        "$(get_prop_from_file "$file" "ro.product.${prefix}.brand" || true)"

    print_value "device" \
        "$(get_prop_from_file "$file" "ro.product.${prefix}.device" || true)"

    print_value "manufacturer" \
        "$(get_prop_from_file "$file" "ro.product.${prefix}.manufacturer" || true)"

    print_value "model" \
        "$(get_prop_from_file "$file" "ro.product.${prefix}.model" || true)"

    print_value "name" \
        "$(get_prop_from_file "$file" "ro.product.${prefix}.name" || true)"

    echo
}


echo "== Build identity =="

SYSTEM_PROP="$OUT/system/build.prop"

print_value "build.id" \
    "$(get_prop_from_file "$SYSTEM_PROP" "ro.build.id" || true)"

print_value "release" \
    "$(get_prop_from_file "$SYSTEM_PROP" "ro.build.version.release" || true)"

print_value "sdk" \
    "$(get_prop_from_file "$SYSTEM_PROP" "ro.build.version.sdk" || true)"

print_value "incremental" \
    "$(get_prop_from_file "$SYSTEM_PROP" "ro.build.version.incremental" || true)"

print_value "type" \
    "$(get_prop_from_file "$SYSTEM_PROP" "ro.build.type" || true)"

print_value "tags" \
    "$(get_prop_from_file "$SYSTEM_PROP" "ro.build.tags" || true)"

print_value "security_patch" \
    "$(get_prop_from_file "$SYSTEM_PROP" "ro.build.version.security_patch" || true)"

print_value "fingerprint" \
    "$(get_prop_from_file "$SYSTEM_PROP" "ro.build.fingerprint" || true)"

echo


echo "== Partition identity =="

print_partition_identity \
    "system" \
    "$OUT/obj/ETC/system_build_prop_intermediates/build.prop" \
    "system"

print_partition_identity \
    "product" \
    "$OUT/system/product/build.prop" \
    "product"

print_partition_identity \
    "vendor" \
    "$OUT/system/vendor/build.prop" \
    "vendor"

print_partition_identity \
    "odm" \
    "$OUT/system/vendor/odm/etc/build.prop" \
    "odm"


echo "== Partition fingerprints =="

for entry in \
    "system:$OUT/system/build.prop:ro.system.build.fingerprint" \
    "product:$OUT/system/product/build.prop:ro.product.build.fingerprint" \
    "vendor:$OUT/system/vendor/build.prop:ro.vendor.build.fingerprint" \
    "odm:$OUT/system/vendor/odm/etc/build.prop:ro.odm.build.fingerprint"
do
    IFS=: read -r name file key <<< "$entry"

    value="$(get_prop_from_file "$file" "$key" || true)"

    printf '%-10s %s\n' "$name" "${value:-<not found>}"
done

echo


echo "== G4 identity consistency =="

SYSTEM_FILE="$OUT/obj/ETC/system_build_prop_intermediates/build.prop"
PRODUCT_FILE="$OUT/system/product/build.prop"
VENDOR_FILE="$OUT/system/vendor/build.prop"
ODM_FILE="$OUT/system/vendor/odm/etc/build.prop"

get_identity() {
    local file="$1"
    local prefix="$2"
    local field="$3"

    get_prop_from_file \
        "$file" \
        "ro.product.${prefix}.${field}" || true
}

EXPECTED_MODEL="$(get_identity "$SYSTEM_FILE" system model)"

if [[ -z "$EXPECTED_MODEL" ]]; then
    echo "[WARN] Unable to determine system model"
else
    echo "Expected model: $EXPECTED_MODEL"

    failures=0
for entry in \
        "system:$SYSTEM_FILE:system" \
        "product:$PRODUCT_FILE:product" \
        "vendor:$VENDOR_FILE:vendor" \
        "odm:$ODM_FILE:odm"
    do
        IFS=: read -r name file prefix <<< "$entry"

        model="$(get_identity "$file" "$prefix" model)"

        if [[ "$model" == "$EXPECTED_MODEL" ]]; then
            echo "[ OK ] $name model: $model"
        else
            echo "[FAIL] $name model: ${model:-<missing>}"
            failures=$((failures + 1))
        fi
    done

    if [[ "$failures" -eq 0 ]]; then
        echo
        echo "[+] Partition model identity is consistent."
    else
        echo
        echo "[!] $failures partition identity mismatch(es)."
    fi
fi

echo


echo "== Unexpected identity references =="

matches="$(
    grep -RInE \
        'google/(pixel|coral|redfin|cheetah|panther)|google/bullhead' \
        "$OUT" \
        2>/dev/null || true
)"

if [[ -n "$matches" ]]; then
    echo "$matches"
else
    echo "[ OK ] No Google/Pixel/Bullhead identity references found."
fi

echo


echo "== Integrity declarations =="

find "$OUT" -type f \
    \( \
        -name 'lg-g4-cts-permissions.xml' \
        -o -name 'lg-g4-cts-features.xml' \
    \) \
    -print 2>/dev/null || true

echo
echo "Report complete."
