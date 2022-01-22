---
permalink: /pgp/
layout: page
title: PGP
---

## Importing ##

You can pipe this page straight into `gpg --import` (be sure to verify the
fingerprint matches the one below after doing so):

```bash
$ curl https://jmarion.dev/pgp/ | gpg --import
gpg: key 45A241CBC3927269: public key "John Marion <john@jmarion.dev>" imported
gpg: Total number processed: 1
gpg:               imported: 1
```

## John Marion \<john@jmarion.dev\> ##

```
pub   ed25519/0x45A241CBC3927269 2021-09-26 [SCA] [expires: 2022-09-26]
      Key fingerprint = 7747 AC6D 60A7 0DA3 AD0B  C5C9 45A2 41CB C392 7269

-----BEGIN PGP PUBLIC KEY BLOCK-----

mDMEYU+4ABYJKwYBBAHaRw8BAQdAqQion/xjQlUSkVbZdpM1MxAhXsOv556zEC73
hXVFJpW0HkpvaG4gTWFyaW9uIDxqb2huQGptYXJpb24uZGV2PoiWBBMWCAA+BQkB
4TOABQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEEd0esbWCnDaOtC8XJRaJBy8OS
cmkFAmFixpYCGyMACgkQRaJBy8OScmnjuAEAwQ3a0aKHWj2ncxs6yNCljPXkl4Ru
xxFwpyc2xO74mS8BAOnyCf08TjTPh8C5LAEJB6CaGD7etAaPmeAapQT9LfMLuDgE
YU+4ABIKKwYBBAGXVQEFAQEHQNOt2U5VTQuClDiVKwzS/fuQbAUP97bRiLgg4Xf5
+U86AwEIB4h+BBgWCAAmFiEEd0esbWCnDaOtC8XJRaJBy8OScmkFAmFPuAACGwwF
CQHhM4AACgkQRaJBy8OScmnDDQD9Hv8fBGJ4WXp8hazEEOoemKlMN+DzwBdsvRLp
MbKjH6wA/0VSIKD+FlATXGRIFrKZn48laWAfqYe3QdU1bM1fF90C
=kJlI
-----END PGP PUBLIC KEY BLOCK-----
```

## Legacy Keys ##

Information on my former PGP keys can be found at
[/pgp-legacy](https://jmarion.dev/pgp-legacy).
