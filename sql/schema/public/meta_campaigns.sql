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
