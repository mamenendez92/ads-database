# ads-database

Repositorio de definición de la base de datos **dbaac** con flujo de trabajo basado en migraciones de Supabase.

## Requisitos

- PostgreSQL 13 o superior.
- Extensión `pgcrypto` habilitada (se crea automáticamente en el script).
- [Supabase CLI](https://supabase.com/docs/guides/cli) instalada y autenticada.

## Estructura

```
supabase/
├── config.toml                # Configuración del proyecto (editada tras `supabase link`).
├── migrations/                # Migraciones SQL (orden cronológico por timestamp).
│   └── 20240101000000_initial_schema.sql
└── seed.sql                   # Datos de ejemplo opcionales ejecutados en `supabase db reset`.
```

La migración `20240101000000_initial_schema.sql` contiene la definición completa de esquemas, tipos,
tablas, índices y funciones necesarias para el proyecto.

## Puesta en marcha

1. Clona este repositorio y accede al directorio:
   ```bash
   git clone <url-del-repositorio>
   cd ads-database
   ```
2. Inicializa la carpeta `supabase/` y vincula el proyecto (si aún no lo hiciste en este equipo):
   ```bash
   supabase init
   supabase link --project-ref <tu-project-ref>
   ```
   Estos comandos actualizan `supabase/config.toml` con las credenciales reales del proyecto.
3. Aplica los cambios de esquema en tu base de datos remota:
   ```bash
   supabase db push
   ```
4. (Opcional) Restablece el esquema local y aplica los datos de prueba definidos en `supabase/seed.sql`:
   ```bash
   supabase db reset
   ```

## Notas

- Para añadir nuevas tablas o modificar las existentes, crea un archivo adicional en `supabase/migrations/`
  siguiendo el formato `<timestamp>_<descripcion>.sql` y ejecuta `supabase db push` para aplicarlo.
- La función `vault._crypto_aead_det_noncegen()` se incluye como implementación mínima basada en
  `gen_random_bytes`. Si tu plataforma ya provee la extensión oficial (`supabase_vault`), elimina o ajusta esa definición.
- Ajusta los índices y restricciones según evolucione el dominio del negocio.
