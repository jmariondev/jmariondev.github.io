+++
title = "PGP"
path = "pgp"
template = "page.html"
+++

## Importing

The easiest way to fetch this key is via [WKD](https://wiki.gnupg.org/WKD)
— both GnuPG and [Sequoia](https://sequoia-pgp.org/) can discover it
automatically from the email address:

```bash
# For GnuPG
$ gpg --locate-keys john@jmarion.dev

# For Sequoia (look at you!)
$ sq network wkd search john@jmarion.dev
```

Or fetch the key directly:

```bash
$ curl -s https://jmarion.dev/pgp-key.asc | gpg --import
$ curl -s https://jmarion.dev/pgp-key.asc | sq cert import
```

Either way, verify the fingerprint matches the one below after importing.

## John Marion \<john@jmarion.dev\>

{{ pgp_info() }}

{{ pgp_key() }}

## Legacy Keys

Information on my former PGP keys can be found at
[/pgp-legacy](/pgp-legacy).
