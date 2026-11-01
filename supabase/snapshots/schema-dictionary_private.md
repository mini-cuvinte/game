# Live schema columns: dictionary_private

Snapshot only; not executable DDL. Defaults are recorded as metadata.

## active_version

| Column | Type | Nullable | Default |
|---|---|---|---|
| singleton | boolean | NO | true |
| version_id | bigint | NO |  |

## entries

| Column | Type | Nullable | Default |
|---|---|---|---|
| version_id | bigint | NO |  |
| word | text | NO |  |

## overrides

| Column | Type | Nullable | Default |
|---|---|---|---|
| word | text | NO |  |
| allowed | boolean | NO |  |
| reason | text | NO |  |
| updated_at | timestamp with time zone | NO | now() |

## versions

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| label | text | NO |  |
| status | text | NO | 'building'::text |
| source | text | NO |  |
| license_approved | boolean | NO | false |
| expected_count | bigint | YES |  |
| checksum | text | YES |  |
| created_at | timestamp with time zone | NO | now() |
| published_at | timestamp with time zone | YES |  |
