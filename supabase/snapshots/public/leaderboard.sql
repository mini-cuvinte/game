CREATE OR REPLACE FUNCTION public.leaderboard(p_limit integer DEFAULT 20)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$begin return coalesce((select jsonb_agg(to_jsonb(x) order by x.wins desc,x.total_score desc) from (select user_id,max(display_name) as name,count(*)::int as games,count(*) filter(where position=1)::int as wins,sum(score)::bigint as total_score,max(score)::int as best_score from public.player_results group by user_id order by wins desc,total_score desc limit least(greatest(coalesce(p_limit,20),1),50)) x),'[]'::jsonb);end $function$
;
