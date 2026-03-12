# Upgrading the formula

Run `./update.sh` — it fetches the latest release tag and SHA256 hashes from GitHub (no downloads) and updates `fizzbee.rb` in place.

```bash
./update.sh
```

The script uses `gh release view --json assets` which includes a `digest` field with the SHA256 for each asset, so no local downloading or hashing is needed.
