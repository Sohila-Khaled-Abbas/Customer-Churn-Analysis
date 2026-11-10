# Data Dictionary — Telecom Churn Analytics

This reference follows the PostgreSQL DDL in `sql/01_staging_tables.sql` and `sql/02_star_schema.sql`. The staging table retains source-level attributes; the dimensional build derives the analytical snapshot and reference tables.

## Source and staging

### `telecom.stg_customers`

| Attribute group | Columns |
|---|---|
| Customer profile | `customer_id`, `gender`, `age`, `married`, `number_of_dependents` |
| Geography | `city`, `zip_code`, `latitude`, `longitude`, `zipcode_population` |
| Tenure / acquisition | `number_of_referrals`, `tenure_in_months`, `sign_up_date`, `sign_up_quarter`, `sign_up_month` |
| Services | `phone_service`, `multiple_lines`, `internet_service`, `internet_type`, `avg_monthly_gb_download`, `online_security`, `online_backup`, `device_protection_plan`, `premium_tech_support`, `streaming_tv`, `streaming_movies`, `streaming_music`, `unlimited_data` |
| Commercial | `offer`, `contract`, `paperless_billing`, `payment_method` |
| Financial | `avg_monthly_long_distance_charges`, `monthly_charges`, `total_charges`, `total_refunds`, `total_extra_data_charges`, `total_long_distance_charges`, `total_revenue` |
| Churn / status | `customer_status`, `churn_category`, `churn_reason`, `churn_flag`, `new_last_quarter`, `high_value` |

## Derived objects

### `telecom.dim_customer`

Customer profile attributes keyed by `customer_id`: gender, age, marital status, and number of dependents.

### `telecom.dim_geo`

Geographic reference by `zip_code`, with `zipcode_population`. The current DDL creates `city` and `county` columns as NULL placeholders.

### `telecom.dim_service`

Distinct service and commercial descriptors: internet type, contract, payment method, phone service, security, premium support, paperless billing, and offer.

### `telecom.fact_customer_snapshot`

Customer-level analytical snapshot containing:

| Column | Meaning |
|---|---|
| `customer_id` | Customer identifier |
| `zip_code` | ZIP identifier, with missing values normalized to `UNKNOWN` |
| `tenure_in_months` | Customer tenure |
| `monthly_charges` | Monthly charge amount |
| `total_revenue` | Total revenue |
| `churn_flag` | 1 when `customer_status` starts with “churn”, otherwise 0 |
| `new_last_quarter` | 1 when tenure is 0–3 months, otherwise 0 |
| `high_value` | 1 when monthly charges meet or exceed the staging population's 75th percentile |
| `contract`, `internet_type`, `payment_method` | Commercial / service segmentation fields |
| `phone_service`, `online_security`, `premium_tech_support`, `paperless_billing`, `offer` | Service and offer attributes |
| `id` | Generated surrogate primary key |

## Materialized views

See [`sql/04_materialized_views.sql`](../sql/04_materialized_views.sql) for the output columns and aggregation definitions of `mv_kpis`, `mv_churn_by_contract`, `mv_churn_by_internet_type`, `mv_churn_by_payment_method`, `mv_levers_matrix`, `mv_churn_by_offer`, `mv_value_segment`, `mv_retention_targets`, and `mv_geo_zip`.

