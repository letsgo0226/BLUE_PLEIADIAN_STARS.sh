# Deployment

This folder adds persistent deployment to the exact Pleiades formal system.

## Docker Compose

```sh
cd deployment
chmod +x deploy.sh run_forever.sh
./deploy.sh
```

The container runs the exact solver every second by default:

`INTERVAL=1`

Persistent runtime state is written under:

`deployment/runtime/`

The application-level invariants remain:

- exact rational arithmetic only
- no floating-point arithmetic in the Zeta/entropy core
- no SHA/hash function in the application logic
- `D(Z(core)) = core`
- `C2` graph automorphism
- quotient state `Gamma_t/C2`
- symbolic direct limit `P_infty = colim_t(Gamma_t/C2)`

## systemd

From inside `deployment/` as root:

```sh
chmod +x install_systemd.sh run_forever.sh
./install_systemd.sh
```

This installs a long-running service named:

`pleiades.service`

Runtime data is stored in:

`/var/lib/pleiades`

## GitHub Actions

`.github/workflows/verify.yml` validates the finite exact invariants on push/PR.

GitHub Actions is used here for verification, not for the one-second resident loop. The one-second loop belongs on the persistent host/container.
