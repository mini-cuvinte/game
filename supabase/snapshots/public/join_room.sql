CREATE OR REPLACE FUNCTION public.join_room(p_code text, p_name text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare v_room public.rooms%rowtype;v_seat smallint;
begin
if auth.uid() is null then raise exception 'Login required';end if;
if length(trim(p_name)) not between 1 and 32 then raise exception 'Invalid name';end if;
select * into v_room from public.rooms where code=upper(trim(p_code)) for update;
if not found or v_room.status<>'lobby' then raise exception 'Room unavailable';end if;
if exists(select 1 from public.room_members where room_id=v_room.id and user_id=auth.uid()) then return v_room.id;end if;
select s into v_seat from generate_series(1,4) s where not exists(select 1 from public.room_members where room_id=v_room.id and seat=s) order by s limit 1;
if v_seat is null then raise exception 'Room full';end if;
insert into public.room_members values(v_room.id,auth.uid(),trim(p_name),v_seat,0);return v_room.id;
end $function$
;
