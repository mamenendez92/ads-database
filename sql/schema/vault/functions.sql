-- Minimal helper to emulate Supabase vault nonce generation when the extension
-- is not available. Adjust if your infrastructure provides the official
-- supabase_vault extension.
CREATE OR REPLACE FUNCTION vault._crypto_aead_det_noncegen()
RETURNS bytea
LANGUAGE sql
AS $$
    SELECT gen_random_bytes(12);
$$;
