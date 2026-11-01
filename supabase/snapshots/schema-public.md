# Live schema columns: public

Snapshot only; not executable DDL. Defaults are recorded as metadata.

## dictionary_words

| Column | Type | Nullable | Default |
|---|---|---|---|
| word | text | NO |  |
| source | text | NO | 'dexonline'::text |
| verified | boolean | NO | false |
| updated_at | timestamp with time zone | NO | now() |

## player_profiles

| Column | Type | Nullable | Default |
|---|---|---|---|
| user_id | uuid | NO |  |
| display_name | text | NO |  |
| created_at | timestamp with time zone | NO | now() |
| updated_at | timestamp with time zone | NO | now() |

## player_results

| Column | Type | Nullable | Default |
|---|---|---|---|
| room_id | uuid | NO |  |
| user_id | uuid | NO |  |
| display_name | text | NO |  |
| score | integer | NO |  |
| position | integer | NO |  |
| recorded_at | timestamp with time zone | NO | now() |

## room_events

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| room_id | uuid | NO |  |
| turn_number | bigint | NO |  |
| actor_id | uuid | YES |  |
| kind | text | NO |  |
| created_at | timestamp with time zone | NO | now() |

## room_members

| Column | Type | Nullable | Default |
|---|---|---|---|
| room_id | uuid | NO |  |
| user_id | uuid | NO |  |
| display_name | text | NO |  |
| seat | smallint | NO |  |
| score | integer | NO | 0 |

## rooms

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | uuid | NO | gen_random_uuid() |
| code | text | NO |  |
| host_id | uuid | NO |  |
| status | text | NO | 'lobby'::text |
| turn_seconds | integer | NO | 120 |
| current_player | uuid | YES |  |
| turn_deadline | timestamp with time zone | YES |  |
| turn_number | bigint | NO | 0 |
| created_at | timestamp with time zone | NO | now() |

## word_requests

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| room_id | uuid | NO |  |
| requested_by | uuid | NO |  |
| word | text | NO |  |
| reason | text | YES |  |
| decision | text | NO | 'pending'::text |
| decided_by | uuid | YES |  |
| created_at | timestamp with time zone | NO | now() |
| decided_at | timestamp with time zone | YES |  |
