CREATE OR REPLACE FUNCTION public.game_snapshot(p_room uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$ declare v jsonb;b jsonb;t text[];n int;reason text;begin v:=public.room_snapshot(p_room);select board,coalesce(array_length(bag,1),0),finish_reason into b,n,reason from private.game_state where room_id=p_room;select tiles into t from private.player_racks where room_id=p_room and user_id=auth.uid();return v||jsonb_build_object('board',coalesce(b,'{}'::jsonb),'my_tiles',coalesce(to_jsonb(t),'[]'::jsonb),'bag_remaining',coalesce(n,0),'finish_reason',reason);end $function$
;
