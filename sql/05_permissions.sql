-- Typical read-only role for BI tools
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'bi_reader') THEN
    CREATE ROLE bi_reader NOINHERIT;
  END IF;
END$$;

GRANT USAGE ON SCHEMA telecom TO bi_reader;
GRANT SELECT ON ALL TABLES IN SCHEMA telecom TO bi_reader;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA telecom TO bi_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA telecom GRANT SELECT ON TABLES TO bi_reader;

-- Assign login role to a user:
-- CREATE USER powerbi LOGIN PASSWORD '***';
-- GRANT bi_reader TO powerbi;
