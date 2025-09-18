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
