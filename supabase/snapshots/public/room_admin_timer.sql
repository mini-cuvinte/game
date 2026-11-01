CREATE OR REPLACE FUNCTION public.room_admin_timer(p_room uuid, p_seconds integer)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$ declare r public.rooms%rowtype;begin select * into r from public.rooms where id=p_room for update;if not found or r.host_id is distinct from auth.uid() then raise exception 'Doar gazda poate schimba timerul';end if;if p_seconds not in (30,60,90,120,180,300,600) then raise exception 'Timer invalid';end if;update public.rooms set turn_seconds=p_seconds,turn_deadline=case when status='playing' then clock_timestamp()+make_interval(secs=>p_seconds) else turn_deadline end where id=p_room;return public.game_snapshot(p_room);end $function$
;
