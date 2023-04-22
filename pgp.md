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

*(Yes. It would be possible for someone to either modify the content of this*
*page on GitHub, or even MitM your requests. If you need better validation,*
*validate the fingerprint with me through some other channel!)*

## John Marion \<john@jmarion.dev\> ##

```
pub   ed25519/0x45A241CBC3927269 2021-09-26 [SCA] [expires: 2024-04-01]
      Key fingerprint = 7747 AC6D 60A7 0DA3 AD0B  C5C9 45A2 41CB C392 7269
uid                             John Marion <john@jmarion.dev>
sub   cv25519/0x1266B253CC3B1FB4 2021-09-26 [E] [expires: 2024-04-01]

-----BEGIN PGP PUBLIC KEY BLOCK-----

mDMEYU+4ABYJKwYBBAHaRw8BAQdAqQion/xjQlUSkVbZdpM1MxAhXsOv556zEC73
hXVFJpW0HkpvaG4gTWFyaW9uIDxqb2huQGptYXJpb24uZGV2PoiWBBMWCgA+BQsJ
CAcCBhUKCQgLAgQWAgMBAh4BAheAAhsjFiEEd0esbWCnDaOtC8XJRaJBy8OScmkF
AmQk0QAFCQS6QQAACgkQRaJBy8OScmngDAEApX8UeghvY4I9u0JUsX62ZxGNpNnF
tMWhPuWepcY5M94A/2U49c06LKdbc6Tb9bYXzZsprVMFGhrSDQzP5tpQ+6QPuDgE
YU+4ABIKKwYBBAGXVQEFAQEHQNOt2U5VTQuClDiVKwzS/fuQbAUP97bRiLgg4Xf5
+U86AwEIB4h+BBgWCgAmAhsMFiEEd0esbWCnDaOtC8XJRaJBy8OScmkFAmQk0QAF
CQS6QQAACgkQRaJBy8OScmlwYgEApFfrdCHta522dX0IsGEQBMFGhPTyuzr7q5Dp
+/xqWK8A/A3Q+nz4wOlkmeWtEGX0qF5f7JSg77TIoYRo0XSdbIMM
=NGW3
-----END PGP PUBLIC KEY BLOCK-----
```

## Legacy Keys ##

Information on my former PGP keys can be found at
[/pgp-legacy](https://jmarion.dev/pgp-legacy).
