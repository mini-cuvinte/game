CREATE OR REPLACE FUNCTION public.save_profile(p_name text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$declare n text:=trim(p_name);begin if auth.uid() is null then raise exception 'Login necesar';end if;if length(n) not between 1 and 32 then raise exception 'Nume invalid';end if;insert into public.player_profiles(user_id,display_name) values(auth.uid(),n) on conflict(user_id) do update set display_name=excluded.display_name,updated_at=now();return jsonb_build_object('name',n);end $function$
;
