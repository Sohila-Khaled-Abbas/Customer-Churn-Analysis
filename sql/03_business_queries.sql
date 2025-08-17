-- 7) Core analytic queries (copy-paste)

-- 7.1 How many customers joined in the last quarter (approx)?
SELECT SUM(new_last_quarter)::int AS customers_joined_last_quarter
FROM telecom.fact_customer_snapshot;

-- 7.2 How many customers total?
SELECT COUNT(*)::int AS total_customers FROM telecom.fact_customer_snapshot;

-- 7.3 How many churned and the churn rate?
SELECT
  SUM(churn_flag)::int AS churned_customers,
  AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM telecom.fact_customer_snapshot;

-- 7.4 Profiles: churned vs stayed vs joined (median monthly_charge, median tenure, top contracts)
-- Profile summary aggregated
WITH seg AS (
  SELECT
    CASE WHEN churn_flag = 1 THEN 'Churned'
         WHEN new_last_quarter = 1 THEN 'Joined_Last_Quarter'
         ELSE 'Stayed' END AS segment,
    monthly_charges,
    total_revenue,
    tenure_in_months,
    contract,
    internet_type,
    payment_method,
    online_security,
    premium_tech_support,
    paperless_billing
  FROM telecom.fact_customer_snapshot
)
SELECT
  segment,
  COUNT(*) AS n,
  percentile_cont(0.5) WITHIN GROUP (ORDER BY monthly_charges) AS median_monthly_charge,
  percentile_cont(0.5) WITHIN GROUP (ORDER BY total_revenue) AS median_total_revenue,
  percentile_cont(0.5) WITHIN GROUP (ORDER BY tenure_in_months) AS median_tenure
FROM seg
GROUP BY segment
ORDER BY n DESC;

-- Top contracts per segment (example)
WITH seg AS (
  SELECT
    CASE WHEN churn_flag = 1 THEN 'Churned'
         WHEN new_last_quarter = 1 THEN 'Joined_Last_Quarter'
         ELSE 'Stayed' END AS segment,
    contract
  FROM telecom.fact_customer_snapshot
)
SELECT segment, contract, COUNT(*) AS n
FROM seg
GROUP BY segment, contract
ORDER BY segment, n DESC;

-- 7.5 Key drivers (univariate)
SELECT contract, COUNT(*) n, AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM telecom.fact_customer_snapshot
GROUP BY contract
ORDER BY churn_rate DESC;

SELECT internet_type, COUNT(*) n, AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM telecom.fact_customer_snapshot
GROUP BY internet_type
ORDER BY churn_rate DESC;

SELECT payment_method, COUNT(*) n, AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM telecom.fact_customer_snapshot
GROUP BY payment_method
ORDER BY churn_rate DESC;

SELECT paperless_billing, COUNT(*) n, AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM telecom.fact_customer_snapshot
GROUP BY paperless_billing
ORDER BY churn_rate DESC;

SELECT online_security, COUNT(*) n, AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM telecom.fact_customer_snapshot
GROUP BY online_security
ORDER BY churn_rate DESC;

SELECT premium_tech_support, COUNT(*) n, AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM telecom.fact_customer_snapshot
GROUP BY premium_tech_support
ORDER BY churn_rate DESC;

-- 7.6 Is the company losing high value customers? (yes/no + counts)
SELECT
  high_value,
  COUNT(*) AS n,
  SUM(churn_flag)::int AS churned,
  AVG(churn_flag::int)::numeric(5,4) AS churn_rate
FROM telecom.fact_customer_snapshot
GROUP BY high_value;

-- 7.7 Retention target list (Operational)
-- High-value, month-to-month, missing add-ons (good for outbound retention)
SELECT customer_id, monthly_charges, contract, internet_type, payment_method, online_security, premium_tech_support, paperless_billing
FROM telecom.fact_customer_snapshot
WHERE high_value = 1
  AND churn_flag = 0
  AND contract ILIKE 'month%'   -- month-to-month
  AND (online_security IS NULL OR lower(online_security) IN ('no','false') OR premium_tech_support IS NULL OR lower(premium_tech_support) IN ('no','false'))
ORDER BY monthly_charges DESC;

-- 8) Optional: materialized view for churn trend per month if you add a signup_date or snapshot_date column
-- Example assumes you later add snapshot_date to fact_customer_snapshot
-- DROP MATERIALIZED VIEW IF EXISTS telecom.mv_monthly_churn;
-- CREATE MATERIALIZED VIEW telecom.mv_monthly_churn AS
-- SELECT date_trunc('month', snapshot_date)::date AS month,
--        COUNT(*) AS customers,
--        SUM(churn_flag)::int AS churned,
--        AVG(churn_flag::int)::numeric(5,4) AS churn_rate
-- FROM telecom.fact_customer_snapshot
-- GROUP BY month
-- ORDER BY month;

-- 9) VACUUM/ANALYZE for perf after big load
VACUUM ANALYZE telecom.stg_customers;
VACUUM ANALYZE telecom.fact_customer_snapshot;