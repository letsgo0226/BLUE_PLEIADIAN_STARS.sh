# Prime Index Hologram

General-n exact integer kernel. `googol` is only one possible input, not a built-in constant.

Single exact query:

```sh
./PRIME_INDEX_HOLOGRAM_TM.sh 25
```

gives `p_25 = 97`.

With no argument, the persisted state advances from `n` to `n+1`:

```sh
./PRIME_INDEX_HOLOGRAM_TM.sh
```

Resident mode:

```sh
INTERVAL=1 ./PRIME_INDEX_HOLOGRAM_RESIDENT.sh
```

Docker:

```sh
cd deployment/prime_index_hologram
docker compose up -d --build
docker compose logs -f
```

State persists in `deployment/prime_index_hologram/runtime/state.json`.

The kernel uses exact integer divisibility only. It computes `p_n` exactly for any finite n in the computability sense, but runtime grows rapidly; enormous n such as `10^100` are not feasible by direct enumeration. The Gödel field is symbolic, avoiding expansion of `2^(p_n+1)3^(n+1)`.

GitHub Actions verifies `p_25=97`, the next persisted state `p_26=101`, hologram reconstruction, exact integer claims, and the container build. GitHub Actions is finite verification only; the always-on resident loop runs on Docker/systemd/local infrastructure.
