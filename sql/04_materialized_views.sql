SET search_path = telecom, public;

-- Materialized views used directly by Power BI for speed and simplicity.

-- 1) Executive KPIs
DROP MATERIALIZED VIEW IF EXISTS telecom.mv_kpis;
CREATE MATERIALIZED VIEW telecom.mv_kpis AS
SELECT
  COUNT(*)::int                       AS customers,
  SUM(churn_flag)::int                AS churned_customers,
  AVG(churn_flag::int)::numeric(5,4)  AS churn_rate,
  SUM(new_last_quarter)::int          AS new_customers_last_quarter,
  SUM(CASE WHEN high_value=1 THEN 1 ELSE 0 END)::int AS high_value_customers,
  AVG(CASE WHEN high_value=1 THEN churn_flag::int ELSE NULL END)::numeric(5,4) AS high_value_churn_rate
FROM telecom.fact_customer_snapshot;

CREATE UNIQUE INDEX IF NOT EXISTS ux_mv_kpis ON mv_kpis ((true));

-- 2) Churn by Contract
DROP MATERIALIZED VIEW IF EXISTS mv_churn_by_contract;
CREATE MATERIALIZED VIEW mv_churn_by_contract AS
SELECT
  contract,
  COUNT(*)::int AS n_customers,
  SUM(churn_flag)::int AS churned,
  AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM fact_customer_snapshot
GROUP BY contract
ORDER BY churn_rate DESC;

CREATE INDEX IF NOT EXISTS ix_mv_churn_by_contract ON mv_churn_by_contract(contract);

-- 3) Churn by Internet Type
DROP MATERIALIZED VIEW IF EXISTS mv_churn_by_internet_type;
CREATE MATERIALIZED VIEW mv_churn_by_internet_type AS
SELECT
  internet_type,
  COUNT(*)::int AS n_customers,
  SUM(churn_flag)::int AS churned,
  AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM fact_customer_snapshot
GROUP BY internet_type
ORDER BY churn_rate DESC;

CREATE INDEX IF NOT EXISTS ix_mv_churn_by_internet_type ON mv_churn_by_internet_type(internet_type);

-- 4) Churn by Payment Method
DROP MATERIALIZED VIEW IF EXISTS mv_churn_by_payment_method;
CREATE MATERIALIZED VIEW mv_churn_by_payment_method AS
SELECT
  payment_method,
  COUNT(*)::int AS n_customers,
  SUM(churn_flag)::int AS churned,
  AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM fact_customer_snapshot
GROUP BY payment_method
ORDER BY churn_rate DESC;

CREATE INDEX IF NOT EXISTS ix_mv_churn_by_payment_method ON mv_churn_by_payment_method(payment_method);

-- 5) Retention Levers Matrix (Online Security x Premium Tech Support)
DROP MATERIALIZED VIEW IF EXISTS mv_levers_matrix;
CREATE MATERIALIZED VIEW mv_levers_matrix AS
SELECT
  COALESCE(online_security,'Unknown') AS online_security,
  COALESCE(premium_tech_support,'Unknown') AS premium_tech_support,
  COUNT(*)::int AS n_customers,
  AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM fact_customer_snapshot
GROUP BY COALESCE(online_security,'Unknown'), COALESCE(premium_tech_support,'Unknown')
ORDER BY churn_rate DESC;

-- 6) Churn by Offer
DROP MATERIALIZED VIEW IF EXISTS mv_churn_by_offer;
CREATE MATERIALIZED VIEW mv_churn_by_offer AS
SELECT
  COALESCE(offer,'None') AS offer,
  COUNT(*)::int AS n_customers,
  SUM(churn_flag)::int AS churned,
  AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM fact_customer_snapshot
GROUP BY COALESCE(offer,'None')
ORDER BY churn_rate DESC;

-- 7) High-Value vs Standard
DROP MATERIALIZED VIEW IF EXISTS mv_value_segment;
CREATE MATERIALIZED VIEW mv_value_segment AS
SELECT
  CASE WHEN high_value=1 THEN 'High' ELSE 'Standard' END AS value_segment,
  COUNT(*)::int AS n_customers,
  SUM(churn_flag)::int AS churned,
  AVG(churn_flag::int)::numeric(5,4) AS churn_rate,
  AVG(monthly_charge)::numeric(10,2) AS avg_monthly_charge
FROM fact_customer_snapshot
GROUP BY CASE WHEN high_value=1 THEN 'High' ELSE 'Standard' END
ORDER BY churn_rate DESC;

-- 8) Retention Target List (operational export)
DROP MATERIALIZED VIEW IF EXISTS mv_retention_targets;
CREATE MATERIALIZED VIEW mv_retention_targets AS
SELECT
  customer_id, monthly_charges, contract, internet_type, payment_method,
  online_security, premium_tech_support, paperless_billing
FROM fact_customer_snapshot
WHERE high_value = 1
  AND churn_flag = 0
  AND contract ILIKE 'month%'
  AND (
        online_security IS NULL OR lower(online_security) IN ('no','false')
     OR premium_tech_support IS NULL OR lower(premium_tech_support) IN ('no','false')
  )
ORDER BY monthly_charges DESC;

-- 9) Geo (ZIP) aggregation
DROP MATERIALIZED VIEW IF EXISTS mv_geo_zip;
CREATE MATERIALIZED VIEW mv_geo_zip AS
SELECT
  f.zip_code,
  COUNT(*)::int AS n_customers,
  SUM(f.churn_flag)::int AS churned,
  AVG(f.churn_flag::int)::numeric(5,4) AS churn_rate
FROM fact_customer_snapshot f
GROUP BY f.zip_code;

-- 10) (Optional) Cohorts if you add signup_date/snapshot_date later
-- Keep placeholder for future use.
