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
