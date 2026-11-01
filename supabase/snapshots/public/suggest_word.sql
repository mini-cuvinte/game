CREATE OR REPLACE FUNCTION public.suggest_word(p_room uuid, p_word text, p_reason text DEFAULT NULL::text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$ declare w text:=upper(trim(p_word));begin if not private.is_member(p_room,auth.uid()) then raise exception 'Nu esti in camera';end if;if w !~ '^[A-Z]{2,20}$' then raise exception 'Cuvantul trebuie sa aiba 2-20 litere A-Z';end if;insert into public.word_requests(room_id,requested_by,word,reason) values(p_room,auth.uid(),w,left(p_reason,250));return jsonb_build_object('submitted',true,'word',w);end $function$
;
