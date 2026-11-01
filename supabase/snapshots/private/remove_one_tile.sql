CREATE OR REPLACE FUNCTION private.remove_one_tile(p_tiles text[], p_tile text)
 RETURNS text[]
 LANGUAGE plpgsql
 IMMUTABLE
 SET search_path TO ''
AS $function$ declare i integer; begin i:=array_position(p_tiles,p_tile);if i is null then raise exception 'Tile not in rack';end if;return coalesce(p_tiles[1:i-1],'{}'::text[])||coalesce(p_tiles[i+1:array_length(p_tiles,1)],'{}'::text[]);end $function$
;
