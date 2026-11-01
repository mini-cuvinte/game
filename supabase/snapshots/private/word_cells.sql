CREATE OR REPLACE FUNCTION private.word_cells(b jsonb, rr integer, cc integer, dr integer, dc integer)
 RETURNS jsonb
 LANGUAGE plpgsql
 IMMUTABLE
 SET search_path TO ''
AS $function$ declare r int:=rr;c int:=cc;a jsonb:='[]'::jsonb;v jsonb;begin while r-dr between 0 and 14 and c-dc between 0 and 14 and b ? ((r-dr)||'-'||(c-dc)) loop r:=r-dr;c:=c-dc;end loop;while r between 0 and 14 and c between 0 and 14 loop v:=b->(r||'-'||c);exit when v is null;a:=a||jsonb_build_array(jsonb_build_object('r',r,'c',c,'letter',v->>'letter','blank',coalesce((v->>'blank')::boolean,false)));r:=r+dr;c:=c+dc;end loop;return a;end $function$
;
