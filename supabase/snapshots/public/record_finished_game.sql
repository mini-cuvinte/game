CREATE OR REPLACE FUNCTION public.record_finished_game(p_room uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$declare st text;begin select status into st from public.rooms where id=p_room;if st is distinct from 'finished' or not exists(select 1 from public.room_members where room_id=p_room and user_id=auth.uid()) then raise exception 'Partida nu este finalizata sau nu esti membru';end if;insert into public.player_results(room_id,user_id,display_name,score,position) select room_id,user_id,display_name,score,dense_rank() over(order by score desc)::integer from public.room_members where room_id=p_room on conflict(room_id,user_id) do nothing;return jsonb_build_object('saved',true);end $function$
;
