# Environment Setup Runbook

## Local Toolchain

1. Enter the Nix shell:
   - `nix develop`
2. Install workspace dependencies:
   - `npm ci`
3. Optional backend Python helper deps:
   - `cd air-mentor-api`
   - `python3 -m pip install -r requirements.txt`

## Backend Environment

1. Review `air-mentor-api/.env.example`.
2. Choose one database posture:
   - local Postgres using `DATABASE_URL`
   - shared Railway test database using `DATABASE_URL` or `RAILWAY_TEST_DATABASE_URL`
3. Run:
   - `npm --workspace air-mentor-api run db:migrate`
   - `npm --workspace air-mentor-api run db:seed`

## Local Startup

- Backend only:
  - `npm --workspace air-mentor-api run dev`
- Frontend only:
  - `npm run dev`
- Local integrated live-like stack:
  - `npm run dev:live`
