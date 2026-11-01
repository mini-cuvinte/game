# Live schema columns: dexonline

Snapshot only; not executable DDL. Defaults are recorded as metadata.

## Abbreviation

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## Definition

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## DefinitionSimple

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## Entry

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## EntryDefinition

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## EntryLexeme

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## Fragment

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## InflectedForm

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## Inflection

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## Lexeme

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## LexemeSource

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## Loc

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## Meaning

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## MeaningSource

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## Model

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## ModelType

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## ObjectTag

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## Relation

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## Source

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## SourceType

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## Tag

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## Tree

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## TreeEntry

| Column | Type | Nullable | Default |
|---|---|---|---|
| id | bigint | NO |  |
| payload | jsonb | NO |  |
| imported_at | timestamp with time zone | NO | now() |

## import_manifest

| Column | Type | Nullable | Default |
|---|---|---|---|
| source_table | text | NO |  |
| imported_rows | bigint | NO | 0 |
| status | text | NO | 'pending'::text |
| updated_at | timestamp with time zone | YES | now() |
