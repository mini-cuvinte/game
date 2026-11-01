CREATE OR REPLACE FUNCTION private.score_word(cells jsonb, new_keys text[])
 RETURNS integer
 LANGUAGE plpgsql
 STABLE
 SET search_path TO ''
AS $function$ declare x jsonb;b text;n int;s int:=0;m int:=1;begin for x in select value from jsonb_array_elements(cells) loop n:=case when (x->>'blank')::boolean then 0 else private.tile_points(x->>'letter') end;if ((x->>'r')||'-'||(x->>'c'))=any(new_keys) then select kind into b from private.bonus_squares where r=(x->>'r')::int and c=(x->>'c')::int;if b='L2' then n:=n*2;elsif b='L3' then n:=n*3;elsif b='C2' then m:=m*2;elsif b='C3' then m:=m*3;end if;end if;s:=s+n;end loop;return s*m;end $function$
;
