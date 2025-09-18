CREATE TABLE IF NOT EXISTS public.configuracion_cierre (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
    plataforma varchar,
    horas_inactividad integer NOT NULL DEFAULT 24,
    descripcion text,
    activo boolean DEFAULT true
);
