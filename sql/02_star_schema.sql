-- TELECOM CHURN ANALYTICS
-- 02) Build the reference dimensions and customer-level fact snapshot.
-- Materialized views are created separately in 04_materialized_views.sql.

CREATE SCHEMA IF NOT EXISTS telecom;
SET search_path = telecom, public;

-- Remove views from both the previous starter build and the current BI layer
-- before rebuilding the fact table they depend on.
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_kpis;
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_churn_by_contract;
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_churn_by_internet_type;
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_churn_by_payment_method;
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_levers_matrix;
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_churn_by_offer;
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_value_segment;
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_retention_targets;
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_geo_zip;
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_high_value_churn; -- legacy starter view

DROP TABLE IF EXISTS telecom.fact_customer_snapshot;
DROP TABLE IF EXISTS telecom.dim_geo;
DROP TABLE IF EXISTS telecom.dim_customer;
DROP TABLE IF EXISTS telecom.dim_service;

-- Geography reference
CREATE TABLE telecom.dim_geo AS
SELECT DISTINCT
  COALESCE(zip_code, 'UNKNOWN')::text AS zip_code,
  zipcode_population::bigint,
  NULL::text AS city,
  NULL::text AS county
FROM telecom.stg_customers;

ALTER TABLE telecom.dim_geo ADD PRIMARY KEY (zip_code);

-- Customer profile reference
CREATE TABLE telecom.dim_customer AS
SELECT DISTINCT
  customer_id::text,
  gender,
  age,
  married,
  number_of_dependents
FROM telecom.stg_customers;

ALTER TABLE telecom.dim_customer ADD PRIMARY KEY (customer_id);

-- Service and commercial descriptors
CREATE TABLE telecom.dim_service AS
SELECT DISTINCT
  internet_type,
  contract,
  payment_method,
  phone_service,
  online_security,
  premium_tech_support,
  paperless_billing,
  offer
FROM telecom.stg_customers;

-- Customer snapshot fact. High value is defined at or above the 75th percentile
-- of monthly_charges in the staged customer population.
CREATE TABLE telecom.fact_customer_snapshot AS
WITH p AS (
  SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY monthly_charges) AS p75
  FROM telecom.stg_customers
)
SELECT
  s.customer_id::text AS customer_id,
  COALESCE(s.zip_code, 'UNKNOWN')::text AS zip_code,
  s.tenure_in_months::integer,
  s.monthly_charges::numeric(10,2),
  s.total_revenue::numeric(12,2),
  CASE WHEN lower(coalesce(s.customer_status,'')) LIKE 'churn%' THEN 1 ELSE 0 END AS churn_flag,
  CASE WHEN s.tenure_in_months BETWEEN 0 AND 3 THEN 1 ELSE 0 END AS new_last_quarter,
  CASE WHEN s.monthly_charges >= (SELECT p75 FROM p) THEN 1 ELSE 0 END AS high_value,
  s.contract,
  s.internet_type,
  s.payment_method,
  s.phone_service,
  s.online_security,
  s.premium_tech_support,
  s.paperless_billing,
  s.offer
FROM telecom.stg_customers AS s;

ALTER TABLE telecom.fact_customer_snapshot
  ADD COLUMN id BIGSERIAL PRIMARY KEY;

-- Indexes used by repeated analytical queries and report filters.
CREATE INDEX IF NOT EXISTS idx_fact_churn_flag
  ON telecom.fact_customer_snapshot (churn_flag);
CREATE INDEX IF NOT EXISTS idx_fact_high_value
  ON telecom.fact_customer_snapshot (high_value);
CREATE INDEX IF NOT EXISTS idx_fact_contract
  ON telecom.fact_customer_snapshot (contract);
CREATE INDEX IF NOT EXISTS idx_fact_internet_type
  ON telecom.fact_customer_snapshot (internet_type);
CREATE INDEX IF NOT EXISTS idx_fact_zip
  ON telecom.fact_customer_snapshot (zip_code);
