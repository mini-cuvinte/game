CREATE OR REPLACE FUNCTION public.create_room(p_name text, p_seconds integer DEFAULT 120)
 RETURNS TABLE(room_id uuid, room_code text)
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$ declare v_id uuid;v_code text;v_tries int:=0;begin if auth.uid() is null then raise exception 'Login required';end if;if length(trim(p_name)) not between 1 and 32 or p_seconds not between 30 and 900 then raise exception 'Invalid settings';end if;loop v_code:=upper(substr(replace(gen_random_uuid()::text,'-',''),1,6));begin insert into public.rooms(code,host_id,turn_seconds) values(v_code,auth.uid(),p_seconds) returning id into v_id;exit;exception when unique_violation then v_tries:=v_tries+1;if v_tries>5 then raise;end if;end;end loop;insert into public.room_members(room_id,user_id,display_name,seat) values(v_id,auth.uid(),trim(p_name),1);return query select v_id,v_code;end $function$
;
