CREATE OR REPLACE FUNCTION public.my_profile()
 RETURNS jsonb
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$begin return coalesce((select jsonb_build_object('name',display_name,'created_at',created_at) from public.player_profiles where user_id=auth.uid()),'{}'::jsonb);end $function$
;
