CREATE OR REPLACE FUNCTION public.start_room(p_room uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare v public.rooms%rowtype;v_count integer;v_bag text[];m record;v_tiles text[];
begin
select * into v from public.rooms where id=p_room for update;
if not found or v.host_id is distinct from auth.uid() or v.status<>'lobby' then raise exception 'Not allowed';end if;
select count(*) into v_count from public.room_members where room_id=p_room;
if v_count<2 then raise exception 'At least two players required';end if;
v_bag:=private.tile_bag();
for m in select user_id from public.room_members where room_id=p_room order by seat loop
v_tiles:=v_bag[1:7];v_bag:=v_bag[8:array_length(v_bag,1)];
insert into private.player_racks(room_id,user_id,tiles) values(p_room,m.user_id,v_tiles);
end loop;
insert into private.game_state(room_id,bag) values(p_room,v_bag);
update public.rooms set status='playing',current_player=(select user_id from public.room_members where room_id=p_room order by seat limit 1),turn_deadline=clock_timestamp()+make_interval(secs=>v.turn_seconds),turn_number=1 where id=p_room;
insert into public.room_events(room_id,turn_number,actor_id,kind) values(p_room,1,auth.uid(),'start');
return public.room_snapshot(p_room);
end $function$
;
