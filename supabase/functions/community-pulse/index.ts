import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Cache response for 1 hour
let cachedResponse: string | null = null;
let cacheExpiry = 0;

serve(async () => {
  const now = Date.now();
  if (cachedResponse && now < cacheExpiry) {
    return new Response(cachedResponse, {
      headers: { "Content-Type": "application/json", "X-Cache": "HIT" },
    });
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  );

  const sevenDaysAgo = new Date(now - 7 * 24 * 60 * 60 * 1000).toISOString();

  const [weeklyActive, topSkills, outcomes, versions, totalRuns] = await Promise.all([
    // Weekly active installations
    supabase
      .from("telemetry_events")
      .select("installation_id", { count: "exact", head: false })
      .gte("event_timestamp", sevenDaysAgo)
      .not("installation_id", "is", null)
      .then(({ data }) => new Set(data?.map((r) => r.installation_id)).size),

    // Top skills (last 30 days)
    supabase
      .from("telemetry_events")
      .select("skill")
      .gte("event_timestamp", new Date(now - 30 * 24 * 60 * 60 * 1000).toISOString())
      .then(({ data }) => {
        const counts: Record<string, number> = {};
        for (const row of data ?? []) {
          if (row.skill) counts[row.skill] = (counts[row.skill] ?? 0) + 1;
        }
        return Object.entries(counts)
          .sort((a, b) => b[1] - a[1])
          .slice(0, 10)
          .map(([skill, count]) => ({ skill, count }));
      }),

    // Outcome breakdown (last 30 days)
    supabase
      .from("telemetry_events")
      .select("outcome")
      .gte("event_timestamp", new Date(now - 30 * 24 * 60 * 60 * 1000).toISOString())
      .then(({ data }) => {
        const counts: Record<string, number> = {};
        for (const row of data ?? []) {
          const o = row.outcome ?? "unknown";
          counts[o] = (counts[o] ?? 0) + 1;
        }
        return counts;
      }),

    // Version distribution
    supabase
      .from("telemetry_events")
      .select("ds_version")
      .gte("event_timestamp", sevenDaysAgo)
      .then(({ data }) => {
        const counts: Record<string, number> = {};
        for (const row of data ?? []) {
          if (row.ds_version) counts[row.ds_version] = (counts[row.ds_version] ?? 0) + 1;
        }
        return Object.entries(counts)
          .sort((a, b) => b[1] - a[1])
          .map(([version, count]) => ({ version, count }));
      }),

    // Total all-time runs
    supabase
      .from("telemetry_events")
      .select("*", { count: "exact", head: true })
      .then(({ count }) => count ?? 0),
  ]);

  const payload = {
    generated_at: new Date().toISOString(),
    total_runs: totalRuns,
    weekly_active_installations: weeklyActive,
    top_skills: topSkills,
    outcomes,
    versions,
  };

  cachedResponse = JSON.stringify(payload);
  cacheExpiry = now + 60 * 60 * 1000;

  return new Response(cachedResponse, {
    headers: { "Content-Type": "application/json", "X-Cache": "MISS" },
  });
});
