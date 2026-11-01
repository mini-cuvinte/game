CREATE OR REPLACE FUNCTION public.room_review_word(p_room uuid, p_request_id bigint, p_approve boolean)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$declare w public.word_requests%rowtype;begin if not exists(select 1 from public.rooms where id=p_room and host_id=auth.uid()) then raise exception 'Doar gazda poate aproba cuvinte';end if;select * into w from public.word_requests where id=p_request_id and room_id=p_room for update;if not found or w.decision<>'pending' then raise exception 'Propunere indisponibila';end if;update public.word_requests set decision=case when p_approve then 'approved' else 'rejected' end,decided_by=auth.uid(),decided_at=now() where id=w.id;if p_approve then insert into private.allowed_words(word,source) values(w.word,'room_host_approved') on conflict(word) do nothing;end if;return jsonb_build_object('word',w.word,'approved',p_approve,'dictionary_updated',p_approve);end $function$
;
