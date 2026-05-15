# SCAP / Notus Data Issues

This note explains why SCAP and Notus data containers often appear unhealthy during the initial feed sync.

Key points:

- The initial sync can take 20–60 minutes depending on disk, network, and feed responsiveness.
- Healthchecks can report unhealthy until a marker file (e.g. `.completed`) is present.
- Check DNS, firewall, and disk space when sync hangs.

Troubleshooting tips:
- Run `docker compose logs scap-data` and `notus-data` to inspect errors.
- Ensure the system clock is correct and TLS can be validated.

(Include additional vendor notes and logs as needed.)
