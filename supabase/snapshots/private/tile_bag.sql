CREATE OR REPLACE FUNCTION private.tile_bag()
 RETURNS text[]
 LANGUAGE sql
 SET search_path TO ''
AS $function$
select array_agg(letter order by random()) from (select x.letter from (values ('A',12),('B',2),('C',6),('D',4),('E',10),('F',2),('G',4),('H',2),('I',10),('J',1),('L',4),('M',4),('N',6),('O',5),('P',4),('R',7),('S',5),('T',7),('U',6),('V',2),('Z',1),('X',1),('?',3)) as x(letter,n) cross join lateral generate_series(1,x.n) s) t;
$function$
;
