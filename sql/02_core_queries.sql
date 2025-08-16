-- =============================================
-- Core Business Queries (PostgreSQL)
-- =============================================
SET search_path TO telecom, public;

-- Q1. How many customers joined the company during the last quarter?
-- Using signup_quarter (best) - replace 'Q2 2025' with your last quarter label
SELECT signup_quarter, COUNT(DISTINCT customer_id) AS customers_joined
FROM fact_customer_snapshot
GROUP BY signup_quarter
ORDER BY signup_quarter DESC;

-- If you prefer dynamic "last quarter" based on max(signup_month):
WITH last_q AS (
  SELECT to_char(date_trunc('quarter', max(signup_month)), '"Q"Q YYYY') AS last_quarter
  FROM fact_customer_snapshot
)
SELECT f.signup_quarter, COUNT(DISTINCT f.customer_id)
FROM fact_customer_snapshot f
JOIN last_q q ON q.last_quarter = f.signup_quarter
GROUP BY f.signup_quarter;

-- Q2. Customer profiles (churned vs joined vs stayed)
WITH seg AS (
  SELECT
    customer_id,
    CASE WHEN churn_flag=1 THEN 'Churned'
         WHEN new_last_quarter=1 THEN 'Joined_Last_Quarter'
         ELSE 'Stayed' END AS segment,
    s.contract,
    s.internet_type,
    s.payment_method,
    tenure_in_months,
    monthly_charge
  FROM fact_customer_snapshot f
  JOIN dim_service s USING (service_key)
)
SELECT segment,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY monthly_charge) AS median_monthly_charge,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY tenure_in_months) AS median_tenure,
       MODE() WITHIN GROUP (ORDER BY contract) AS top_contract,
       MODE() WITHIN GROUP (ORDER BY internet_type) AS top_internet_type,
       MODE() WITHIN GROUP (ORDER BY payment_method) AS top_payment_method,
       COUNT(*) AS n
FROM seg
GROUP BY segment
ORDER BY segment;

-- Q3. Key drivers (univariate scans)
SELECT s.contract, ROUND(AVG(f.churn_flag)::numeric,4) AS churn_rate, COUNT(*) AS n
FROM fact_customer_snapshot f JOIN dim_service s USING (service_key)
GROUP BY s.contract ORDER BY churn_rate DESC;

SELECT s.internet_type, ROUND(AVG(f.churn_flag)::numeric,4) AS churn_rate, COUNT(*) AS n
FROM fact_customer_snapshot f JOIN dim_service s USING (service_key)
GROUP BY s.internet_type ORDER BY churn_rate DESC;

SELECT s.payment_method, ROUND(AVG(f.churn_flag)::numeric,4) AS churn_rate, COUNT(*) AS n
FROM fact_customer_snapshot f JOIN dim_service s USING (service_key)
GROUP BY s.payment_method ORDER BY churn_rate DESC;

SELECT s.online_security, ROUND(AVG(f.churn_flag)::numeric,4) AS churn_rate, COUNT(*) AS n
FROM fact_customer_snapshot f JOIN dim_service s USING (service_key)
GROUP BY s.online_security ORDER BY churn_rate DESC;

SELECT s.premium_tech_support, ROUND(AVG(f.churn_flag)::numeric,4) AS churn_rate, COUNT(*) AS n
FROM fact_customer_snapshot f JOIN dim_service s USING (service_key)
GROUP BY s.premium_tech_support ORDER BY churn_rate DESC;

-- Q4. Is the company losing high value customers?
SELECT high_value,
       ROUND(AVG(churn_flag)::numeric,4) AS churn_rate,
       COUNT(*) AS n
FROM fact_customer_snapshot
GROUP BY high_value
ORDER BY high_value DESC;

-- Retention target list: High value + Month-to-month + No online security/tech support
SELECT f.customer_id, f.monthly_charge, s.contract, s.internet_type, s.payment_method
FROM fact_customer_snapshot f
JOIN dim_service s USING (service_key)
WHERE f.high_value = 1
  AND s.contract = 'Month-to-month'
  AND (s.online_security = 'No' OR s.premium_tech_support = 'No')
  AND f.churn_flag = 0;