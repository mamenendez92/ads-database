CREATE TABLE IF NOT EXISTS auth.sessions (
    id uuid PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES auth.users (id),
    created_at timestamptz,
    updated_at timestamptz,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamptz,
    refreshed_at timestamp,
    user_agent text,
    ip inet,
    tag text
);

CREATE INDEX IF NOT EXISTS sessions_user_idx ON auth.sessions (user_id);
