import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const VALID_EVENT_TYPES = new Set(["skill_run"]);
const VALID_OUTCOMES = new Set(["success", "error", "abort", "unknown"]);
const MAX_BATCH = 100;

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("method not allowed", { status: 405 });
  }

  let events: unknown[];
  try {
    events = await req.json();
    if (!Array.isArray(events)) events = [events];
  } catch {
    return new Response(JSON.stringify({ error: "invalid json" }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const valid: Record<string, unknown>[] = [];
  const upsertInstallations: Record<string, unknown>[] = [];
  const seen = new Set<string>();

  for (const raw of events.slice(0, MAX_BATCH)) {
    const e = raw as Record<string, unknown>;

    // Required fields
    if (!e.ts || !e.ds_version || !e.os || !e.outcome) continue;
    if (!VALID_EVENT_TYPES.has(String(e.event_type ?? "skill_run"))) continue;
    if (!VALID_OUTCOMES.has(String(e.outcome))) continue;

    const row: Record<string, unknown> = {
      schema_version:  Number(e.v ?? 1),
      event_type:      String(e.event_type ?? "skill_run").slice(0, 50),
      ds_version:      String(e.ds_version).slice(0, 20),
      os:              String(e.os).slice(0, 20),
      arch:            String(e.arch ?? "").slice(0, 20),
      event_timestamp: String(e.ts),
      skill:           String(e.skill ?? "").slice(0, 50),
      session_id:      String(e.session_id ?? "").slice(0, 50),
      duration_s:      isFinite(Number(e.duration_s)) ? Number(e.duration_s) : null,
      outcome:         String(e.outcome).slice(0, 20),
      installation_id: e.installation_id ? String(e.installation_id).slice(0, 64) : null,
    };

    valid.push(row);

    // Track installation upsert (dedupe within batch)
    if (row.installation_id && !seen.has(String(row.installation_id))) {
      seen.add(String(row.installation_id));
      upsertInstallations.push({
        installation_id: row.installation_id,
        last_seen:       row.event_timestamp,
        ds_version:      row.ds_version,
        os:              row.os,
      });
    }
  }

  if (valid.length === 0) {
    return new Response(JSON.stringify({ inserted: 0 }), {
      headers: { "Content-Type": "application/json" },
    });
  }

  const { error: insertError } = await supabase
    .from("telemetry_events")
    .insert(valid);

  if (insertError) {
    console.error("insert error:", insertError);
    return new Response(JSON.stringify({ error: insertError.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }

  // Upsert installations (best-effort, don't fail the request)
  if (upsertInstallations.length > 0) {
    await supabase
      .from("installations")
      .upsert(upsertInstallations, { onConflict: "installation_id", ignoreDuplicates: false })
      .catch(() => {});
  }

  return new Response(JSON.stringify({ inserted: valid.length }), {
    headers: { "Content-Type": "application/json" },
  });
});
