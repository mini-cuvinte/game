-- Reconstructed from live catalog metadata; application schemas only.
-- Run on a NEW Supabase project, not against existing production.
BEGIN;
CREATE SCHEMA IF NOT EXISTS private;
CREATE SCHEMA IF NOT EXISTS dictionary_private;

CREATE TABLE IF NOT EXISTS "dictionary_private"."active_version" (
  "singleton" boolean DEFAULT true NOT NULL,
  "version_id" bigint NOT NULL
);

CREATE TABLE IF NOT EXISTS "dictionary_private"."entries" (
  "version_id" bigint NOT NULL,
  "word" text NOT NULL
);

CREATE TABLE IF NOT EXISTS "dictionary_private"."overrides" (
  "word" text NOT NULL,
  "allowed" boolean NOT NULL,
  "reason" text NOT NULL,
  "updated_at" timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS "dictionary_private"."versions" (
  "id" bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  "label" text NOT NULL,
  "status" text DEFAULT 'building'::text NOT NULL,
  "source" text NOT NULL,
  "license_approved" boolean DEFAULT false NOT NULL,
  "expected_count" bigint,
  "checksum" text,
  "created_at" timestamptz DEFAULT now() NOT NULL,
  "published_at" timestamptz
);

CREATE TABLE IF NOT EXISTS "private"."allowed_words" (
  "word" text NOT NULL,
  "source" text DEFAULT 'starter'::text NOT NULL
);

CREATE TABLE IF NOT EXISTS "private"."bonus_squares" (
  "r" integer NOT NULL,
  "c" integer NOT NULL,
  "kind" text NOT NULL
);

CREATE TABLE IF NOT EXISTS "private"."game_state" (
  "room_id" uuid NOT NULL,
  "board" jsonb DEFAULT '{}'::jsonb NOT NULL,
  "bag" text[] NOT NULL,
  "updated_at" timestamptz DEFAULT now() NOT NULL,
  "consecutive_passes" integer DEFAULT 0 NOT NULL,
  "finish_reason" text
);

CREATE TABLE IF NOT EXISTS "private"."player_racks" (
  "room_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "tiles" text[] DEFAULT '{}'::text[] NOT NULL
);

CREATE TABLE IF NOT EXISTS "public"."dictionary_words" (
  "word" text NOT NULL,
  "source" text DEFAULT 'dexonline'::text NOT NULL,
  "verified" boolean DEFAULT false NOT NULL,
  "updated_at" timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS "public"."player_profiles" (
  "user_id" uuid NOT NULL,
  "display_name" text NOT NULL,
  "created_at" timestamptz DEFAULT now() NOT NULL,
  "updated_at" timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS "public"."player_results" (
  "room_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "display_name" text NOT NULL,
  "score" integer NOT NULL,
  "position" integer NOT NULL,
  "recorded_at" timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS "public"."room_events" (
  "id" bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  "room_id" uuid NOT NULL,
  "turn_number" bigint NOT NULL,
  "actor_id" uuid,
  "kind" text NOT NULL,
  "created_at" timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS "public"."room_members" (
  "room_id" uuid NOT NULL,
  "user_id" uuid NOT NULL,
  "display_name" text NOT NULL,
  "seat" int2 NOT NULL,
  "score" integer DEFAULT 0 NOT NULL
);

CREATE TABLE IF NOT EXISTS "public"."rooms" (
  "id" uuid DEFAULT gen_random_uuid() NOT NULL,
  "code" text NOT NULL,
  "host_id" uuid NOT NULL,
  "status" text DEFAULT 'lobby'::text NOT NULL,
  "turn_seconds" integer DEFAULT 120 NOT NULL,
  "current_player" uuid,
  "turn_deadline" timestamptz,
  "turn_number" bigint DEFAULT 0 NOT NULL,
  "created_at" timestamptz DEFAULT now() NOT NULL
);

CREATE TABLE IF NOT EXISTS "public"."word_requests" (
  "id" bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  "room_id" uuid NOT NULL,
  "requested_by" uuid NOT NULL,
  "word" text NOT NULL,
  "reason" text,
  "decision" text DEFAULT 'pending'::text NOT NULL,
  "decided_by" uuid,
  "created_at" timestamptz DEFAULT now() NOT NULL,
  "decided_at" timestamptz
);

COMMIT;
