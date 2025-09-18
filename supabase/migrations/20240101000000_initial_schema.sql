-- Initial schema migration equivalent to the former sql/create_database.sql script.
-- Creates required schemas, extensions, types, functions, tables, and indexes.

-- Ensure cryptographic helpers are available
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Ensure required schemas exist
CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS storage;
CREATE SCHEMA IF NOT EXISTS vault;

-- Supporting type for the auth schema
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

-- Supporting functions
CREATE OR REPLACE FUNCTION vault._crypto_aead_det_noncegen()
RETURNS bytea
LANGUAGE sql
AS $$
    SELECT gen_random_bytes(12);
$$;

-- Public schema tables
CREATE TABLE IF NOT EXISTS public.contactos (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
    nombre_mostrado varchar,
    primer_nombre varchar,
    nombre_completo varchar,
    telefono varchar,
    email varchar,
    zona_horaria varchar
);

CREATE TABLE IF NOT EXISTS public.conversaciones (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
    contacto_id uuid REFERENCES public.contactos (id),
    plataforma varchar,
    external_thread_id varchar,
    started_at timestamptz,
    closed_at timestamptz,
    utm_source varchar,
    utm_medium varchar,
    utm_campaign varchar,
    utm_adset varchar,
    utm_ad varchar,
    estado varchar,
    ultimo_recibido_at timestamptz,
    ultimo_enviado_at timestamptz
);

CREATE INDEX IF NOT EXISTS conversaciones_contacto_idx ON public.conversaciones (contacto_id);

CREATE TABLE IF NOT EXISTS public.meta_campaigns (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
    meta_campaign_id varchar NOT NULL,
    campaign_id varchar NOT NULL,
    nombre_campana varchar,
    descripcion text
);

CREATE UNIQUE INDEX IF NOT EXISTS meta_campaigns_ids_idx
    ON public.meta_campaigns (meta_campaign_id, campaign_id);

CREATE TABLE IF NOT EXISTS public.meta_conjuntos (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
    meta_adset_id varchar NOT NULL,
    adset_id varchar NOT NULL,
    campaign_id varchar,
    nombre_conjunto varchar,
    descripcion text
);

CREATE UNIQUE INDEX IF NOT EXISTS meta_conjuntos_ids_idx
    ON public.meta_conjuntos (meta_adset_id, adset_id);

CREATE TABLE IF NOT EXISTS public.meta_anuncios (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
    meta_ad_id varchar NOT NULL,
    ad_id varchar NOT NULL,
    adset_id varchar,
    nombre_anuncio varchar,
    descripcion text
);

CREATE UNIQUE INDEX IF NOT EXISTS meta_anuncios_ids_idx
    ON public.meta_anuncios (meta_ad_id, ad_id);

CREATE TABLE IF NOT EXISTS public.configuracion_cierre (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
    plataforma varchar,
    horas_inactividad integer NOT NULL DEFAULT 24,
    descripcion text,
    activo boolean DEFAULT true
);

-- Auth schema tables
CREATE TABLE IF NOT EXISTS auth.users (
    instance_id uuid,
    id uuid PRIMARY KEY,
    aud varchar,
    role varchar,
    email varchar,
    encrypted_password varchar,
    email_confirmed_at timestamptz,
    invited_at timestamptz,
    confirmation_token varchar,
    confirmation_sent_at timestamptz,
    recovery_token varchar,
    recovery_sent_at timestamptz,
    email_change_token_new varchar,
    email_change varchar,
    email_change_sent_at timestamptz,
    last_sign_in_at timestamptz,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamptz,
    updated_at timestamptz,
    phone text UNIQUE,
    phone_confirmed_at timestamptz,
    phone_change varchar DEFAULT ''::varchar,
    phone_change_token varchar DEFAULT ''::varchar,
    phone_change_sent_at timestamptz,
    confirmed_at timestamptz GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current varchar DEFAULT ''::varchar,
    email_change_confirm_status smallint DEFAULT 0 CHECK (email_change_confirm_status >= 0 AND email_change_confirm_status <= 2),
    banned_until timestamptz,
    reauthentication_token varchar DEFAULT ''::varchar,
    reauthentication_sent_at timestamptz,
    is_sso_user boolean NOT NULL DEFAULT false,
    deleted_at timestamptz
);

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

-- Storage schema tables
CREATE TABLE IF NOT EXISTS storage.buckets (
    id text PRIMARY KEY,
    name text NOT NULL,
    owner uuid,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);

CREATE TABLE IF NOT EXISTS storage.objects (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamptz DEFAULT now(),
    updated_at timestamptz DEFAULT now(),
    last_accessed_at timestamptz DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/')) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);

CREATE INDEX IF NOT EXISTS objects_bucket_name_idx
    ON storage.objects (bucket_id, name);

-- Vault schema tables
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
