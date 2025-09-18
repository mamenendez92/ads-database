DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_type t
        JOIN pg_namespace n ON n.oid = t.typnamespace
        WHERE t.typname = 'aal_level'
          AND n.nspname = 'auth'
    ) THEN
        CREATE TYPE auth.aal_level AS ENUM ('aal1', 'aal2', 'aal3');
    END IF;
END
$$;
