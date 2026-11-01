CREATE OR REPLACE FUNCTION public.advance_turn(p_room uuid, p_expected_turn bigint)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare rm public.rooms%rowtype;next_id uuid;expired boolean;pass_count int;member record;penalty int;
begin
select * into rm from public.rooms where id=p_room for update;
if not found or not private.is_member(p_room,auth.uid()) or rm.status<>'playing' or rm.turn_number<>p_expected_turn then raise exception 'Tură invalidă';end if;
expired:=clock_timestamp()>=rm.turn_deadline;
if not expired and rm.current_player is distinct from auth.uid() then raise exception 'Nu este tura ta';end if;
update private.game_state set consecutive_passes=consecutive_passes+1 where room_id=p_room returning consecutive_passes into pass_count;
insert into public.room_events(room_id,turn_number,actor_id,kind) values(p_room,rm.turn_number,auth.uid(),case when expired then 'timeout' else 'pass' end);
if pass_count>=(select count(*)*2 from public.room_members where room_id=p_room) then
for member in select user_id from public.room_members where room_id=p_room loop
select coalesce(sum(private.tile_points(t)),0) into penalty from private.player_racks pr cross join lateral unnest(pr.tiles) t where pr.room_id=p_room and pr.user_id=member.user_id;
update public.room_members set score=score-penalty where room_id=p_room and user_id=member.user_id;
end loop;
update public.rooms set status='finished',turn_deadline=null where id=p_room;
update private.game_state set finish_reason='consecutive_passes' where room_id=p_room;
else
select user_id into next_id from public.room_members where room_id=p_room and seat>(select seat from public.room_members where room_id=p_room and user_id=rm.current_player) order by seat limit 1;
if next_id is null then select user_id into next_id from public.room_members where room_id=p_room order by seat limit 1;end if;
update public.rooms set current_player=next_id,turn_number=turn_number+1,turn_deadline=clock_timestamp()+make_interval(secs=>rm.turn_seconds) where id=p_room;
end if;
return public.game_snapshot(p_room);
end $function$
;
