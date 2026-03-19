#!/usr/bin/env bash
set -euo pipefail

KEY_UID="john@jmarion.dev"
WKD_HASH="wwq7w9d96wfsd4zkytndq84kpkjod3eb"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! gpg --list-keys "$KEY_UID" &>/dev/null; then
    echo "error: key for $KEY_UID not found in keyring" >&2
    exit 1
fi

# Key listing (verbatim gpg output)
echo "==> Updating pgp-info.txt"
gpg --keyid-format long --with-fingerprint --list-keys "$KEY_UID" 2>/dev/null \
    | grep -E '^(pub|uid|sub|      Key)' \
    > "$REPO_ROOT/static/pgp-info.txt"

# ASCII-armored public key
echo "==> Updating pgp-key.asc"
gpg --armor --export --export-options export-minimal "$KEY_UID" \
    > "$REPO_ROOT/static/pgp-key.asc"

# WKD binary key (advanced method: openpgpkey.jmarion.dev, direct method: jmarion.dev)
echo "==> Updating WKD binary"
mkdir -p "$REPO_ROOT/static/.well-known/openpgpkey/jmarion.dev/hu"
mkdir -p "$REPO_ROOT/static/.well-known/openpgpkey/hu"
gpg --no-armor --export --export-options export-minimal "$KEY_UID" \
    > "$REPO_ROOT/static/.well-known/openpgpkey/jmarion.dev/hu/$WKD_HASH"
cp "$REPO_ROOT/static/.well-known/openpgpkey/jmarion.dev/hu/$WKD_HASH" \
    "$REPO_ROOT/static/.well-known/openpgpkey/hu/$WKD_HASH"
touch "$REPO_ROOT/static/.well-known/openpgpkey/policy"

# Update security.txt expiry to match key expiry
EXPIRY=$(gpg --keyid-format long --with-fingerprint --list-keys "$KEY_UID" 2>/dev/null \
    | grep -oP 'expires: \K[0-9-]+' | head -1)
if [ -n "$EXPIRY" ]; then
    echo "==> Updating security.txt (expires: $EXPIRY)"
    cat > "$REPO_ROOT/static/.well-known/security.txt" << EOF
Contact: mailto:john@jmarion.dev
Encryption: https://jmarion.dev/pgp-key.asc
Expires: ${EXPIRY}T00:00:00.000Z
Preferred-Languages: en
Canonical: https://jmarion.dev/.well-known/security.txt
EOF
    echo "    Remember to re-sign: gpg --clearsign $REPO_ROOT/static/.well-known/security.txt && mv $REPO_ROOT/static/.well-known/security.txt.asc $REPO_ROOT/static/.well-known/security.txt"
fi

echo "==> Done. Review changes with: git diff"
echo "    Optionally sign security.txt: gpg --clearsign $REPO_ROOT/static/.well-known/security.txt && mv $REPO_ROOT/static/.well-known/security.txt.asc $REPO_ROOT/static/.well-known/security.txt"
