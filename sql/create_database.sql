-- Database bootstrap script for dbaac
-- Creates the database and required extensions/schemas.

\set ON_ERROR_STOP on

CREATE DATABASE dbaac;

\connect dbaac

-- Required for gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Ensure supporting schemas exist
CREATE SCHEMA IF NOT EXISTS auth;
CREATE SCHEMA IF NOT EXISTS storage;
CREATE SCHEMA IF NOT EXISTS vault;

-- Supporting functions
\ir schema/vault/functions.sql

-- Public schema tables
\ir schema/public/contactos.sql
\ir schema/public/conversaciones.sql
\ir schema/public/meta_campaigns.sql
\ir schema/public/meta_conjuntos.sql
\ir schema/public/meta_anuncios.sql
\ir schema/public/configuracion_cierre.sql

-- Auth schema tables
\ir schema/auth/aal_level_type.sql
\ir schema/auth/users.sql
\ir schema/auth/sessions.sql

-- Storage schema tables
\ir schema/storage/buckets.sql
\ir schema/storage/objects.sql

-- Vault schema tables
\ir schema/vault/secrets.sql
