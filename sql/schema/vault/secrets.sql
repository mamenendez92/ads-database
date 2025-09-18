CREATE TABLE IF NOT EXISTS vault.secrets (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text,
    description text DEFAULT ''::text,
    secret text NOT NULL,
    key_id uuid,
    nonce bytea DEFAULT vault._crypto_aead_det_noncegen(),
    created_at timestamptz DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamptz DEFAULT CURRENT_TIMESTAMP
);
