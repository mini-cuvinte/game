-- Non-constraint indexes. Apply after constraints.
CREATE INDEX dictionary_entries_word_idx ON dictionary_private.entries USING btree (word);
CREATE INDEX player_results_ranking ON public.player_results USING btree (user_id, score DESC);
CREATE INDEX word_requests_room_idx ON public.word_requests USING btree (room_id, decision);
