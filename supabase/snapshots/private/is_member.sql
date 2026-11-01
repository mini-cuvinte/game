CREATE OR REPLACE FUNCTION private.is_member(p_room uuid, p_user uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$ select exists(select 1 from public.room_members where room_id=p_room and user_id=p_user) $function$
;
