-- designStack telemetry schema
-- Run this in your Supabase SQL editor before deploying edge functions

CREATE TABLE IF NOT EXISTS telemetry_events (
  id               UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  received_at      TIMESTAMPTZ NOT NULL    DEFAULT now(),
  schema_version   INTEGER,
  event_type       TEXT,
  ds_version       TEXT,
  os               TEXT,
  arch             TEXT,
  event_timestamp  TIMESTAMPTZ,
  skill            TEXT,
  session_id       TEXT,
  duration_s       NUMERIC,
  outcome          TEXT,
  installation_id  TEXT        -- nullable; only for community tier
);

CREATE TABLE IF NOT EXISTS installations (
  installation_id  TEXT        PRIMARY KEY,
  first_seen       TIMESTAMPTZ NOT NULL DEFAULT now(),
  last_seen        TIMESTAMPTZ,
  ds_version       TEXT,
  os               TEXT
);

-- Performance indices
CREATE INDEX IF NOT EXISTS idx_telemetry_ts
  ON telemetry_events (event_timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_telemetry_skill
  ON telemetry_events (skill, event_timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_telemetry_errors
  ON telemetry_events (outcome, ds_version)
  WHERE outcome != 'success';

-- RLS: anon key can INSERT only, never SELECT
ALTER TABLE telemetry_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE installations    ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "insert_only" ON telemetry_events;
DROP POLICY IF EXISTS "insert_only" ON installations;
DROP POLICY IF EXISTS "upsert_only" ON installations;

CREATE POLICY "insert_only" ON telemetry_events
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "insert_only" ON installations
  FOR INSERT TO anon WITH CHECK (true);

CREATE POLICY "upsert_only" ON installations
  FOR UPDATE TO anon USING (true);
