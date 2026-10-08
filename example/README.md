# cross_promo_example

Minimal example of the `cross_promo` package: a full section and a banner,
on the remote catalog (falls back to the embedded catalog when offline).

Its main purpose is to check that the package compiles for the web:

```bash
cd example
flutter build web          # dart2js
flutter build web --wasm   # dart2wasm
```
