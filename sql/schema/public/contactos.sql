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
