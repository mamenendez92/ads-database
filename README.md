# ads-database

Repositorio de definición de la base de datos **dbaac**.

## Requisitos

- PostgreSQL 13 o superior.
- Acceso a la utilidad `psql`.
- Extensión `pgcrypto` habilitada (se crea automáticamente en el script).

## Estructura

```
sql/
├── create_database.sql        # Script maestro que crea la base y ejecuta el resto.
└── schema/
    ├── auth/                  # Objetos del esquema auth (usuarios, sesiones, enum AAL...).
    ├── public/                # Tablas principales del dominio.
    ├── storage/               # Objetos de gestión de archivos.
    └── vault/                 # Tablas y funciones necesarias para secretos.
```

Cada archivo `*.sql` define un objeto (tabla, tipo, función o índice). El script principal
utiliza `\include` para cargar los archivos en orden.

## Creación de la base de datos

1. Clona este repositorio y accede al directorio:
   ```bash
   git clone <url-del-repositorio>
   cd ads-database
   ```
2. Ejecuta el script principal con un rol que tenga privilegios de superusuario (para crear la base y extensiones):
   ```bash
   psql -f sql/create_database.sql
   ```
   El script creará la base `dbaac`, instalará las extensiones necesarias, y generará los esquemas y tablas.

## Notas

- La función `vault._crypto_aead_det_noncegen()` se incluye como implementación mínima basada en `gen_random_bytes`.
  Si tu plataforma ya provee la extensión oficial (`supabase_vault`), elimina o ajusta esa definición.
- Ajusta los índices y restricciones según evolucione el dominio del negocio.
- Para añadir nuevas tablas o modificar las existentes, crea archivos adicionales dentro de `sql/schema/<esquema>/`
  y agrégalos al `sql/create_database.sql` siguiendo el orden deseado.
