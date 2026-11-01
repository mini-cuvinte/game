-- Live PostgreSQL index definitions. Some indexes implement constraints.
-- Do not replay without deduplicating constraint-backed indexes.

-- dexonline.Abbreviation: Abbreviation_pkey
CREATE UNIQUE INDEX "Abbreviation_pkey" ON dexonline."Abbreviation" USING btree (id);

-- dexonline.Definition: Definition_pkey
CREATE UNIQUE INDEX "Definition_pkey" ON dexonline."Definition" USING btree (id);

-- dexonline.DefinitionSimple: DefinitionSimple_pkey
CREATE UNIQUE INDEX "DefinitionSimple_pkey" ON dexonline."DefinitionSimple" USING btree (id);

-- dexonline.Entry: Entry_pkey
CREATE UNIQUE INDEX "Entry_pkey" ON dexonline."Entry" USING btree (id);

-- dexonline.EntryDefinition: EntryDefinition_pkey
CREATE UNIQUE INDEX "EntryDefinition_pkey" ON dexonline."EntryDefinition" USING btree (id);

-- dexonline.EntryLexeme: EntryLexeme_pkey
CREATE UNIQUE INDEX "EntryLexeme_pkey" ON dexonline."EntryLexeme" USING btree (id);

-- dexonline.Fragment: Fragment_pkey
CREATE UNIQUE INDEX "Fragment_pkey" ON dexonline."Fragment" USING btree (id);

-- dexonline.InflectedForm: InflectedForm_pkey
CREATE UNIQUE INDEX "InflectedForm_pkey" ON dexonline."InflectedForm" USING btree (id);

-- dexonline.InflectedForm: dex_inflected_payload_form
CREATE INDEX dex_inflected_payload_form ON dexonline."InflectedForm" USING btree (((payload ->> 'formNoAccent'::text)));

-- dexonline.Inflection: Inflection_pkey
CREATE UNIQUE INDEX "Inflection_pkey" ON dexonline."Inflection" USING btree (id);

-- dexonline.Lexeme: Lexeme_pkey
CREATE UNIQUE INDEX "Lexeme_pkey" ON dexonline."Lexeme" USING btree (id);

-- dexonline.Lexeme: dex_lexeme_payload_form
CREATE INDEX dex_lexeme_payload_form ON dexonline."Lexeme" USING btree (((payload ->> 'formNoAccent'::text)));

-- dexonline.LexemeSource: LexemeSource_pkey
CREATE UNIQUE INDEX "LexemeSource_pkey" ON dexonline."LexemeSource" USING btree (id);

-- dexonline.Loc: Loc_pkey
CREATE UNIQUE INDEX "Loc_pkey" ON dexonline."Loc" USING btree (id);

-- dexonline.Meaning: Meaning_pkey
CREATE UNIQUE INDEX "Meaning_pkey" ON dexonline."Meaning" USING btree (id);

-- dexonline.MeaningSource: MeaningSource_pkey
CREATE UNIQUE INDEX "MeaningSource_pkey" ON dexonline."MeaningSource" USING btree (id);

-- dexonline.Model: Model_pkey
CREATE UNIQUE INDEX "Model_pkey" ON dexonline."Model" USING btree (id);

-- dexonline.ModelType: ModelType_pkey
CREATE UNIQUE INDEX "ModelType_pkey" ON dexonline."ModelType" USING btree (id);

-- dexonline.ObjectTag: ObjectTag_pkey
CREATE UNIQUE INDEX "ObjectTag_pkey" ON dexonline."ObjectTag" USING btree (id);

-- dexonline.Relation: Relation_pkey
CREATE UNIQUE INDEX "Relation_pkey" ON dexonline."Relation" USING btree (id);

-- dexonline.Source: Source_pkey
CREATE UNIQUE INDEX "Source_pkey" ON dexonline."Source" USING btree (id);

-- dexonline.SourceType: SourceType_pkey
CREATE UNIQUE INDEX "SourceType_pkey" ON dexonline."SourceType" USING btree (id);

-- dexonline.Tag: Tag_pkey
CREATE UNIQUE INDEX "Tag_pkey" ON dexonline."Tag" USING btree (id);

-- dexonline.Tree: Tree_pkey
CREATE UNIQUE INDEX "Tree_pkey" ON dexonline."Tree" USING btree (id);

-- dexonline.TreeEntry: TreeEntry_pkey
CREATE UNIQUE INDEX "TreeEntry_pkey" ON dexonline."TreeEntry" USING btree (id);

-- dexonline.import_manifest: import_manifest_pkey
CREATE UNIQUE INDEX import_manifest_pkey ON dexonline.import_manifest USING btree (source_table);

-- dictionary_private.active_version: active_version_pkey
CREATE UNIQUE INDEX active_version_pkey ON dictionary_private.active_version USING btree (singleton);

-- dictionary_private.entries: dictionary_entries_word_idx
CREATE INDEX dictionary_entries_word_idx ON dictionary_private.entries USING btree (word);

-- dictionary_private.entries: entries_pkey
CREATE UNIQUE INDEX entries_pkey ON dictionary_private.entries USING btree (version_id, word);

-- dictionary_private.overrides: overrides_pkey
CREATE UNIQUE INDEX overrides_pkey ON dictionary_private.overrides USING btree (word);

-- dictionary_private.versions: versions_label_key
CREATE UNIQUE INDEX versions_label_key ON dictionary_private.versions USING btree (label);

-- dictionary_private.versions: versions_pkey
CREATE UNIQUE INDEX versions_pkey ON dictionary_private.versions USING btree (id);

-- private.allowed_words: allowed_words_pkey
CREATE UNIQUE INDEX allowed_words_pkey ON private.allowed_words USING btree (word);

-- private.bonus_squares: bonus_squares_pkey
CREATE UNIQUE INDEX bonus_squares_pkey ON private.bonus_squares USING btree (r, c);

-- private.game_state: game_state_pkey
CREATE UNIQUE INDEX game_state_pkey ON private.game_state USING btree (room_id);

-- private.player_racks: player_racks_pkey
CREATE UNIQUE INDEX player_racks_pkey ON private.player_racks USING btree (room_id, user_id);

-- public.dictionary_words: dictionary_words_pkey
CREATE UNIQUE INDEX dictionary_words_pkey ON public.dictionary_words USING btree (word);

-- public.player_profiles: player_profiles_pkey
CREATE UNIQUE INDEX player_profiles_pkey ON public.player_profiles USING btree (user_id);

-- public.player_results: player_results_pkey
CREATE UNIQUE INDEX player_results_pkey ON public.player_results USING btree (room_id, user_id);

-- public.player_results: player_results_ranking
CREATE INDEX player_results_ranking ON public.player_results USING btree (user_id, score DESC);

-- public.room_events: room_events_pkey
CREATE UNIQUE INDEX room_events_pkey ON public.room_events USING btree (id);

-- public.room_members: room_members_pkey
CREATE UNIQUE INDEX room_members_pkey ON public.room_members USING btree (room_id, user_id);

-- public.room_members: room_members_room_id_seat_key
CREATE UNIQUE INDEX room_members_room_id_seat_key ON public.room_members USING btree (room_id, seat);

-- public.rooms: rooms_code_key
CREATE UNIQUE INDEX rooms_code_key ON public.rooms USING btree (code);

-- public.rooms: rooms_pkey
CREATE UNIQUE INDEX rooms_pkey ON public.rooms USING btree (id);

-- public.word_requests: word_requests_pkey
CREATE UNIQUE INDEX word_requests_pkey ON public.word_requests USING btree (id);

-- public.word_requests: word_requests_room_idx
CREATE INDEX word_requests_room_idx ON public.word_requests USING btree (room_id, decision);
