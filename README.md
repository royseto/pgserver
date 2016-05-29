This Dockerfile starts a running PostgreSQL server on port 6543. It creates a
data volume at /mnt/data/pgsql that contains a basic empty database cluster
configured for testing but not production (small memory parameters, NOT SECURE,
logs to stderr). This image can also mount a production database disk at
/mnt/data/pgsql that contains suitable production settings.
