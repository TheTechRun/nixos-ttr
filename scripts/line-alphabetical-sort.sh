#!/usr/bin/env bash

read -rp "Enter the path to the nix file: " filepath
filepath="${filepath/#\~/$HOME}"

if [[ ! -f "$filepath" ]]; then
    echo "Error: File not found: $filepath"
    exit 1
fi

tmpfile=$(mktemp)
tmpblock=$(mktemp)
tmpprocessed=$(mktemp)

start_line=$(grep -n 'home\.packages = with pkgs; \[' "$filepath" | head -1 | cut -d: -f1)
end_line=$(awk -v start="$start_line" 'NR > start && /^[[:space:]]*\];/ { print NR; exit }' "$filepath")

if [[ -z "$start_line" || -z "$end_line" ]]; then
    echo "Error: Could not find home.packages block in $filepath"
    rm -f "$tmpfile" "$tmpblock" "$tmpprocessed"
    exit 1
fi

sed -n "$((start_line + 1)),$((end_line - 1))p" "$filepath" > "$tmpblock"

awk '
{
    line = $0
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
    if (line == "") next

    key = line
    gsub(/^[[:space:]]*#+[[:space:]]*/, "", key)
    pkg = tolower(key)
    sub(/[[:space:]].*/, "", pkg)

    if (pkg == "" || seen[pkg]++) next

    print pkg "\t" line
}' "$tmpblock" | sort -t$'\t' -k1,1 | cut -f2- > "$tmpprocessed"

{
    sed -n "1,${start_line}p" "$filepath"
    cat "$tmpprocessed"
    sed -n "${end_line},\$p" "$filepath"
} > "$tmpfile"

mv "$tmpfile" "$filepath"
rm -f "$tmpblock" "$tmpprocessed"

echo "Done: sorted and deduplicated home.packages in $filepath"
