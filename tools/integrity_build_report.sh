#!/usr/bin/env bash
set -euo pipefail

OUT="${1:-}"
[[ -n "$OUT" && -d "$OUT" ]] || { echo "Usage: $0 out/target/product/<product>" >&2; exit 2; }

PROP_FILES=()
for f in "$OUT/system/build.prop" "$OUT/system/etc/prop.default" \
         "$OUT/system_ext/build.prop" "$OUT/vendor/build.prop" \
         "$OUT/product/build.prop" "$OUT/odm/build.prop"; do
    [[ -f "$f" ]] && PROP_FILES+=("$f")
done

get_prop() {
    local key="$1" f value
    for f in "${PROP_FILES[@]}"; do
        value="$(awk -F= -v k="$key" '$1 == k {sub(/^[^=]*=/, ""); print; exit}' "$f")"
        if [[ -n "$value" ]]; then printf '%s' "$value"; return 0; fi
    done
    return 1
}

print_prop() {
    local key="$1" value
    if value="$(get_prop "$key")"; then
        printf '%-40s %s\n' "$key" "$value"
    else
        printf '%-40s %s\n' "$key" "<not found>"
    fi
}

echo "============================================================"
echo " LG G4 Integrity / Identity Build Report"
echo "============================================================"
echo "Output: $OUT"
echo

echo "== Device identity =="
for p in ro.product.brand ro.product.manufacturer ro.product.model ro.product.device ro.product.name; do
    print_prop "$p"
done

echo
echo "== Build identity =="
for p in ro.build.id ro.build.version.release ro.build.version.sdk ro.build.version.incremental ro.build.type ro.build.tags ro.build.fingerprint ro.build.version.security_patch; do
    print_prop "$p"
done

echo
echo "== Partition fingerprints =="
for p in ro.system.build.fingerprint ro.system_ext.build.fingerprint ro.product.build.fingerprint ro.vendor.build.fingerprint ro.odm.build.fingerprint; do
    print_prop "$p"
done

echo
echo "== Integrity declarations =="
find "$OUT" -type f \
    \( -name 'lg-g4-cts-permissions.xml' -o -name 'lg-g4-cts-features.xml' \) \
    -print 2>/dev/null || true

echo
echo "Report complete."
