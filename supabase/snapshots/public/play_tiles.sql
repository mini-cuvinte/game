CREATE OR REPLACE FUNCTION public.play_tiles(p_room uuid, p_expected_turn bigint, p_placements jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
declare rm public.rooms%rowtype;gs private.game_state%rowtype;rack text[];b jsonb;cnt int;minr int:=15;maxr int:=-1;minc int:=15;maxc int:=-1;r int;c int;x jsonb;l text;src text;k text;used text[]:='{}';connected boolean:=false;pts int:=0;next_id uuid;drawn int;tiles text[];dr int;dc int;main_word jsonb;cross_word jsonb;w text;words text[]:='{}';i int;penalty int;member record;
begin
select * into rm from public.rooms where id=p_room for update;
if not found or rm.status<>'playing' or rm.turn_number<>p_expected_turn or rm.current_player is distinct from auth.uid() or clock_timestamp()>=rm.turn_deadline then raise exception 'Nu este tura ta sau timpul a expirat';end if;
if p_placements is null or jsonb_typeof(p_placements)<>'array' or jsonb_array_length(p_placements) not between 1 and 7 then raise exception 'Alege între 1 și 7 litere';end if;
select * into gs from private.game_state where room_id=p_room for update;
select pr.tiles into rack from private.player_racks pr where pr.room_id=p_room and pr.user_id=auth.uid() for update;
b:=gs.board;cnt:=jsonb_array_length(p_placements);
for x in select value from jsonb_array_elements(p_placements) loop
if jsonb_typeof(x)<>'object' or (x->>'r') !~ '^(0|[1-9]|1[0-4])$' or (x->>'c') !~ '^(0|[1-9]|1[0-4])$' then raise exception 'Coordonate invalide';end if;
r:=(x->>'r')::int;c:=(x->>'c')::int;l:=upper(x->>'letter');
if l is null or l !~ '^[A-Z]$' then raise exception 'Literă invalidă';end if;
src:=case when coalesce((x->>'blank')::boolean,false) then '?' else l end;k:=r||'-'||c;
if b ? k then raise exception 'Căsuță ocupată';end if;
rack:=private.remove_one_tile(rack,src);b:=jsonb_set(b,array[k],jsonb_build_object('letter',l,'blank',src='?'));used:=array_append(used,k);
minr:=least(minr,r);maxr:=greatest(maxr,r);minc:=least(minc,c);maxc:=greatest(maxc,c);
end loop;
if minr<>maxr and minc<>maxc then raise exception 'Literele trebuie să fie pe același rând sau coloană';end if;
if minr=maxr then dr:=0;dc:=1;else dr:=1;dc:=0;end if;
main_word:=private.word_cells(b,minr,minc,dr,dc);
if jsonb_array_length(main_word)<2 then
main_word:=private.word_cells(b,minr,minc,1,0);dr:=1;dc:=0;
end if;
if jsonb_array_length(main_word)<2 then raise exception 'Formează un cuvânt de minimum 2 litere';end if;
for i in 1..array_length(used,1) loop
if not exists(select 1 from jsonb_array_elements(main_word) z where (z->>'r')||'-'||(z->>'c')=used[i]) then raise exception 'Mutarea conține spații între litere';end if;
end loop;
if gs.board='{}'::jsonb then
if not exists(select 1 from jsonb_array_elements(main_word) z where z->>'r'='7' and z->>'c'='7') then raise exception 'Primul cuvânt trebuie să treacă prin stea';end if;
else
for x in select value from jsonb_array_elements(p_placements) loop
r:=(x->>'r')::int;c:=(x->>'c')::int;
if gs.board ? ((r+1)||'-'||c) or gs.board ? ((r-1)||'-'||c) or gs.board ? (r||'-'||(c+1)) or gs.board ? (r||'-'||(c-1)) then connected:=true;end if;
end loop;
if not connected then raise exception 'Mutarea trebuie să atingă un cuvânt existent';end if;
end if;
w:=private.check_word(main_word);pts:=private.score_word(main_word,used);words:=array_append(words,w);
for x in select value from jsonb_array_elements(p_placements) loop
r:=(x->>'r')::int;c:=(x->>'c')::int;
cross_word:=private.word_cells(b,r,c,dc,dr);
if jsonb_array_length(cross_word)>1 then
w:=private.check_word(cross_word);pts:=pts+private.score_word(cross_word,used);words:=array_append(words,w);
end if;
end loop;
if cnt=7 then pts:=pts+50;end if;
drawn:=least(7-coalesce(array_length(rack,1),0),coalesce(array_length(gs.bag,1),0));
tiles:=rack||coalesce(gs.bag[1:drawn],'{}'::text[]);
update private.player_racks set tiles=play_tiles.tiles where room_id=p_room and user_id=auth.uid();
update private.game_state set board=b,bag=coalesce(gs.bag[drawn+1:array_length(gs.bag,1)],'{}'::text[]),consecutive_passes=0,updated_at=clock_timestamp() where room_id=p_room;
update public.room_members set score=score+pts where room_id=p_room and user_id=auth.uid();
if coalesce(array_length(gs.bag,1),0)=drawn and coalesce(array_length(tiles,1),0)=0 then
for member in select user_id from public.room_members where room_id=p_room loop
select coalesce(sum(private.tile_points(t)),0) into penalty from private.player_racks pr cross join lateral unnest(pr.tiles) t where pr.room_id=p_room and pr.user_id=member.user_id;
update public.room_members set score=score-penalty where room_id=p_room and user_id=member.user_id;
if member.user_id<>auth.uid() then update public.room_members set score=score+penalty where room_id=p_room and user_id=auth.uid();end if;
end loop;
update public.rooms set status='finished',turn_deadline=null where id=p_room;
update private.game_state set finish_reason='empty_rack' where room_id=p_room;
else
select user_id into next_id from public.room_members where room_id=p_room and seat>(select seat from public.room_members where room_id=p_room and user_id=auth.uid()) order by seat limit 1;
if next_id is null then select user_id into next_id from public.room_members where room_id=p_room order by seat limit 1;end if;
update public.rooms set current_player=next_id,turn_number=turn_number+1,turn_deadline=clock_timestamp()+make_interval(secs=>rm.turn_seconds) where id=p_room;
end if;
return public.game_snapshot(p_room)||jsonb_build_object('last_words',to_jsonb(words),'last_score',pts);
end $function$
;
