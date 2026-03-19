serve:
    zola serve --drafts

build:
    zola build

# Update PGP key material across the site after renewing in your local keyring.
# Updates: content/pgp.md, WKD binary, security.txt expiry.
update-pgp:
    ./scripts/update-pgp.sh
