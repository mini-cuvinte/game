# Live schema columns: private

Snapshot only; not executable DDL. Defaults are recorded as metadata.

## allowed_words

| Column | Type | Nullable | Default |
|---|---|---|---|
| word | text | NO |  |
| source | text | NO | 'starter'::text |

## bonus_squares

| Column | Type | Nullable | Default |
|---|---|---|---|
| r | integer | NO |  |
| c | integer | NO |  |
| kind | text | NO |  |

## game_state

| Column | Type | Nullable | Default |
|---|---|---|---|
| room_id | uuid | NO |  |
| board | jsonb | NO | '{}'::jsonb |
| bag | ARRAY | NO |  |
| updated_at | timestamp with time zone | NO | now() |
| consecutive_passes | integer | NO | 0 |
| finish_reason | text | YES |  |

## player_racks

| Column | Type | Nullable | Default |
|---|---|---|---|
| room_id | uuid | NO |  |
| user_id | uuid | NO |  |
| tiles | ARRAY | NO | '{}'::text[] |
