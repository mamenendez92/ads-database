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
