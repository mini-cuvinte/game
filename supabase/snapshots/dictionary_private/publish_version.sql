CREATE OR REPLACE FUNCTION dictionary_private.publish_version(p_version bigint)
 RETURNS void
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare v dictionary_private.versions%rowtype; n bigint;
begin
 perform pg_advisory_xact_lock(7788231);
 select * into v from dictionary_private.versions where id=p_version for update;
 if not found or v.status not in ('ready','archived') or not v.license_approved then
   raise exception 'Version missing, not ready or license not approved';
 end if;
 select count(*) into n from dictionary_private.entries where version_id=p_version;
 if n=0 or v.expected_count is distinct from n or v.checksum is null then
   raise exception 'Invalid count/checksum for version %',p_version;
 end if;
 insert into dictionary_private.active_version(singleton,version_id) values(true,p_version)
 on conflict(singleton) do update set version_id=excluded.version_id;
 update dictionary_private.versions set status='archived' where id<>p_version and status='ready';
 update dictionary_private.versions set status='ready',published_at=now() where id=p_version;
end $function$
;
