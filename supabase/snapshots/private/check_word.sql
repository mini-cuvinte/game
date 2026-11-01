CREATE OR REPLACE FUNCTION private.check_word(cells jsonb)
 RETURNS text
 LANGUAGE plpgsql
 STABLE
 SET search_path TO ''
AS $function$ declare w text;begin select string_agg(x->>'letter','' order by ord) into w from jsonb_array_elements(cells) with ordinality t(x,ord);if length(w)<2 then raise exception 'Cuvântul trebuie să aibă minimum 2 litere';end if;if not exists(select 1 from private.allowed_words where word=w) then raise exception 'Cuvântul % nu este în dicționarul beta',w;end if;return w;end $function$
;
