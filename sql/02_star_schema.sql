-- 2) Star schema: dims + fact

-- 2.1 Dim: geo
DROP TABLE IF EXISTS telecom.dim_geo;
CREATE TABLE telecom.dim_geo AS
SELECT DISTINCT
  COALESCE(zip_code, 'UNKNOWN')::text AS zip_code,
  zipcode_population::bigint,
  NULL::text AS city,
  NULL::text AS county
FROM telecom.stg_customers;

ALTER TABLE telecom.dim_geo ADD PRIMARY KEY (zip_code);

-- 2.2 Dim: customer
DROP TABLE IF EXISTS telecom.dim_customer;
CREATE TABLE telecom.dim_customer AS
SELECT DISTINCT
  customer_id::text,
  gender,
  age,
  married,
  number_of_dependents
FROM telecom.stg_customers;

ALTER TABLE telecom.dim_customer ADD PRIMARY KEY (customer_id);

-- 2.3 Dim: service
DROP TABLE IF EXISTS telecom.dim_service;
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

-- 2.4 Fact: snapshot (compute high_value using p75 of monthly_charge)
DROP TABLE IF EXISTS telecom.fact_customer_snapshot;
CREATE TABLE telecom.fact_customer_snapshot AS
WITH p as (
  SELECT percentile_cont(0.75) WITHIN GROUP (ORDER BY telecom.stg_customers.monthly_charges) AS p75
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
FROM telecom.stg_customers s;

-- Add a surrogate key for the fact table if you want
ALTER TABLE telecom.fact_customer_snapshot ADD COLUMN id BIGSERIAL PRIMARY KEY;

-- 3) Indexes to speed reports
CREATE INDEX IF NOT EXISTS idx_fact_churn_flag ON telecom.fact_customer_snapshot (churn_flag);
CREATE INDEX IF NOT EXISTS idx_fact_high_value ON telecom.fact_customer_snapshot (high_value);
CREATE INDEX IF NOT EXISTS idx_fact_contract ON telecom.fact_customer_snapshot (contract);
CREATE INDEX IF NOT EXISTS idx_fact_internet_type ON telecom.fact_customer_snapshot (internet_type);
CREATE INDEX IF NOT EXISTS idx_fact_zip ON telecom.fact_customer_snapshot (zip_code);

-- 4) Useful materialized views / pre-aggregations

-- 4.1 churn by segment (materialized)
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_churn_by_contract;
CREATE MATERIALIZED VIEW telecom.mv_churn_by_contract AS
SELECT contract,
       COUNT(*) AS n_customers,
       AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM telecom.fact_customer_snapshot
GROUP BY contract
ORDER BY churn_rate DESC;

-- 4.2 churn by internet_type
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_churn_by_internet_type;
CREATE MATERIALIZED VIEW telecom.mv_churn_by_internet_type AS
SELECT internet_type,
       COUNT(*) AS n_customers,
       AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM telecom.fact_customer_snapshot
GROUP BY internet_type
ORDER BY churn_rate DESC;

-- 4.3 high-value churn summary
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_high_value_churn;
CREATE MATERIALIZED VIEW telecom.mv_high_value_churn AS
SELECT high_value,
       COUNT(*) AS n_customers,
       AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM telecom.fact_customer_snapshot
GROUP BY high_value;

-- NOTE: refresh later with REFRESH MATERIALIZED VIEW telecom.mv_churn_by_contract;
