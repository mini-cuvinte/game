CREATE OR REPLACE FUNCTION private.tile_points(p text)
 RETURNS integer
 LANGUAGE sql
 IMMUTABLE
 SET search_path TO ''
AS $function$
select case p when 'A' then 2 when 'B' then 8 when 'C' then 1 when 'D' then 2 when 'E' then 1 when 'F' then 8 when 'G' then 9 when 'H' then 8 when 'I' then 1 when 'J' then 8 when 'L' then 1 when 'M' then 4 when 'N' then 1 when 'O' then 1 when 'P' then 2 when 'R' then 1 when 'S' then 1 when 'T' then 1 when 'U' then 1 when 'V' then 8 when 'Z' then 8 when 'X' then 8 else 0 end;
$function$
;
