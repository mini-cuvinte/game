CREATE OR REPLACE FUNCTION public.room_snapshot(p_room uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare v jsonb;
begin
if auth.uid() is null or not private.is_member(p_room,auth.uid()) then raise exception 'Access denied';end if;
select jsonb_build_object('id',r.id,'code',r.code,'status',r.status,'host_id',r.host_id,'turn_seconds',r.turn_seconds,'current_player',r.current_player,'turn_deadline',r.turn_deadline,'turn_number',r.turn_number,'server_now',clock_timestamp(),'members',(select coalesce(jsonb_agg(jsonb_build_object('user_id',m.user_id,'name',m.display_name,'seat',m.seat,'score',m.score) order by m.seat),'[]'::jsonb) from public.room_members m where m.room_id=r.id)) into v from public.rooms r where r.id=p_room;return v;
end $function$
;
