CREATE OR REPLACE FUNCTION public.room_word_requests(p_room uuid)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$begin if not exists(select 1 from public.rooms where id=p_room and host_id=auth.uid()) then raise exception 'Doar gazda poate vedea propunerile';end if;return coalesce((select jsonb_agg(jsonb_build_object('id',w.id,'word',w.word,'reason',w.reason,'decision',w.decision,'created_at',w.created_at) order by w.created_at desc) from public.word_requests w where w.room_id=p_room),'[]'::jsonb);end $function$
;
