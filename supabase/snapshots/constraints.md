# Live database constraints

Snapshot of constraint definitions; not an executable migration.

| Schema | Table | Constraint | Type | Definition |
|---|---|---|---|---|
| dexonline | Abbreviation | Abbreviation_pkey | p | PRIMARY KEY (id) |
| dexonline | Definition | Definition_pkey | p | PRIMARY KEY (id) |
| dexonline | DefinitionSimple | DefinitionSimple_pkey | p | PRIMARY KEY (id) |
| dexonline | Entry | Entry_pkey | p | PRIMARY KEY (id) |
| dexonline | EntryDefinition | EntryDefinition_pkey | p | PRIMARY KEY (id) |
| dexonline | EntryLexeme | EntryLexeme_pkey | p | PRIMARY KEY (id) |
| dexonline | Fragment | Fragment_pkey | p | PRIMARY KEY (id) |
| dexonline | InflectedForm | InflectedForm_pkey | p | PRIMARY KEY (id) |
| dexonline | Inflection | Inflection_pkey | p | PRIMARY KEY (id) |
| dexonline | Lexeme | Lexeme_pkey | p | PRIMARY KEY (id) |
| dexonline | LexemeSource | LexemeSource_pkey | p | PRIMARY KEY (id) |
| dexonline | Loc | Loc_pkey | p | PRIMARY KEY (id) |
| dexonline | Meaning | Meaning_pkey | p | PRIMARY KEY (id) |
| dexonline | MeaningSource | MeaningSource_pkey | p | PRIMARY KEY (id) |
| dexonline | Model | Model_pkey | p | PRIMARY KEY (id) |
| dexonline | ModelType | ModelType_pkey | p | PRIMARY KEY (id) |
| dexonline | ObjectTag | ObjectTag_pkey | p | PRIMARY KEY (id) |
| dexonline | Relation | Relation_pkey | p | PRIMARY KEY (id) |
| dexonline | Source | Source_pkey | p | PRIMARY KEY (id) |
| dexonline | SourceType | SourceType_pkey | p | PRIMARY KEY (id) |
| dexonline | Tag | Tag_pkey | p | PRIMARY KEY (id) |
| dexonline | Tree | Tree_pkey | p | PRIMARY KEY (id) |
| dexonline | TreeEntry | TreeEntry_pkey | p | PRIMARY KEY (id) |
| dexonline | import_manifest | import_manifest_pkey | p | PRIMARY KEY (source_table) |
| dictionary_private | active_version | active_version_pkey | p | PRIMARY KEY (singleton) |
| dictionary_private | active_version | active_version_singleton_check | c | CHECK (singleton) |
| dictionary_private | active_version | active_version_version_id_fkey | f | FOREIGN KEY (version_id) REFERENCES dictionary_private.versions(id) |
| dictionary_private | entries | entries_pkey | p | PRIMARY KEY (version_id, word) |
| dictionary_private | entries | entries_version_id_fkey | f | FOREIGN KEY (version_id) REFERENCES dictionary_private.versions(id) ON DELETE CASCADE |
| dictionary_private | entries | entries_word_check | c | CHECK ((word ~ '^[A-Z]{2,20}$'::text)) |
| dictionary_private | overrides | overrides_pkey | p | PRIMARY KEY (word) |
| dictionary_private | overrides | overrides_word_check | c | CHECK ((word ~ '^[A-Z]{2,20}$'::text)) |
| dictionary_private | versions | versions_label_key | u | UNIQUE (label) |
| dictionary_private | versions | versions_pkey | p | PRIMARY KEY (id) |
| dictionary_private | versions | versions_status_check | c | CHECK ((status = ANY (ARRAY['building'::text, 'ready'::text, 'archived'::text]))) |
| private | allowed_words | allowed_words_pkey | p | PRIMARY KEY (word) |
| private | bonus_squares | bonus_squares_pkey | p | PRIMARY KEY (r, c) |
| private | game_state | game_state_pkey | p | PRIMARY KEY (room_id) |
| private | game_state | game_state_room_id_fkey | f | FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE |
| private | player_racks | player_racks_pkey | p | PRIMARY KEY (room_id, user_id) |
| private | player_racks | player_racks_room_id_fkey | f | FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE |
| private | player_racks | player_racks_user_id_fkey | f | FOREIGN KEY (user_id) REFERENCES auth.users(id) |
| public | dictionary_words | dictionary_words_pkey | p | PRIMARY KEY (word) |
| public | player_profiles | player_profiles_display_name_check | c | CHECK (((length(display_name) >= 1) AND (length(display_name) <= 32))) |
| public | player_profiles | player_profiles_pkey | p | PRIMARY KEY (user_id) |
| public | player_profiles | player_profiles_user_id_fkey | f | FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE |
| public | player_results | player_results_pkey | p | PRIMARY KEY (room_id, user_id) |
| public | player_results | player_results_room_id_fkey | f | FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE |
| public | player_results | player_results_user_id_fkey | f | FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE |
| public | room_events | room_events_actor_id_fkey | f | FOREIGN KEY (actor_id) REFERENCES auth.users(id) |
| public | room_events | room_events_kind_check | c | CHECK ((kind = ANY (ARRAY['start'::text, 'pass'::text, 'timeout'::text]))) |
| public | room_events | room_events_pkey | p | PRIMARY KEY (id) |
| public | room_events | room_events_room_id_fkey | f | FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE |
| public | room_members | room_members_display_name_check | c | CHECK (((length(display_name) >= 1) AND (length(display_name) <= 32))) |
| public | room_members | room_members_pkey | p | PRIMARY KEY (room_id, user_id) |
| public | room_members | room_members_room_id_fkey | f | FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE |
| public | room_members | room_members_room_id_seat_key | u | UNIQUE (room_id, seat) |
| public | room_members | room_members_seat_check | c | CHECK (((seat >= 1) AND (seat <= 4))) |
| public | room_members | room_members_user_id_fkey | f | FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE |
| public | rooms | rooms_code_check | c | CHECK ((code ~ '^[A-Z0-9]{6}$'::text)) |
| public | rooms | rooms_code_key | u | UNIQUE (code) |
| public | rooms | rooms_current_player_fkey | f | FOREIGN KEY (current_player) REFERENCES auth.users(id) |
| public | rooms | rooms_host_id_fkey | f | FOREIGN KEY (host_id) REFERENCES auth.users(id) |
| public | rooms | rooms_pkey | p | PRIMARY KEY (id) |
| public | rooms | rooms_status_check | c | CHECK ((status = ANY (ARRAY['lobby'::text, 'playing'::text, 'finished'::text]))) |
| public | rooms | rooms_turn_seconds_check | c | CHECK (((turn_seconds >= 30) AND (turn_seconds <= 900))) |
| public | word_requests | word_requests_decided_by_fkey | f | FOREIGN KEY (decided_by) REFERENCES auth.users(id) |
| public | word_requests | word_requests_decision_check | c | CHECK ((decision = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text]))) |
| public | word_requests | word_requests_pkey | p | PRIMARY KEY (id) |
| public | word_requests | word_requests_requested_by_fkey | f | FOREIGN KEY (requested_by) REFERENCES auth.users(id) |
| public | word_requests | word_requests_room_id_fkey | f | FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE |
