# Supabase migration history

The live database reports these applied migrations. This is a **history inventory**, not the original migration SQL.

| Version | Migration |
|---|---|
| 20261029171246 | initial_multiplayer_lobby_and_server_turn_timer |
| 20261029171306 | restrict_rpc_execution_to_authenticated |
| 20261029172201 | private_bag_racks_and_server_move_validation |
| 20261029172214 | fix_duplicate_letter_consumption |
| 20261029172457 | fix_room_code_generation_without_pgcrypto_gen_random_bytes |
| 20261029173040 | bonus_and_starter_dictionary_v2 |
| 20261029173056 | server_scoring_dictionary_move_v2 |
| 20261029173104 | end_game_after_passes_v2 |
| 20261029174735 | room_host_timer_and_word_moderation |
| 20261029174746 | prevent_cross_room_dictionary_pollution |
| 20261029174912 | player_profiles_and_persistent_leaderboard |
| 20261029175057 | correct_persistent_results_recording |
| 20261029175631 | activate_approved_words_in_dictionary |
| 20261030184707 | dexonline_23_tables_staging |

The snapshot files in this repository are not guaranteed to be replayable in dependency order. Original migration SQL, grants, roles, extension settings and data still need a separate verified export.
