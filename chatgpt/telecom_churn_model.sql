
-- TELECOM CHURN STAR SCHEMA (Generic SQL) for this dataset

-- Staging: create stg_customers and bulk load /mnt/data/telecom_customers_clean.csv

-- Dimensions
CREATE TABLE dim_geo AS
SELECT DISTINCT
    COALESCE(zip_code, 'UNKNOWN') AS zip_code,
    population
FROM stg_customers;

CREATE TABLE dim_customer AS
SELECT DISTINCT
    customer_id,
    gender,
    age,
    married,
    number_of_dependents
FROM stg_customers;

CREATE TABLE dim_service AS
SELECT DISTINCT
    COALESCE(internet_type, 'Unknown') AS internet_type,
    COALESCE(contract, 'Unknown') AS contract,
    COALESCE(payment_method, 'Unknown') AS payment_method,
    COALESCE(phone_service, 'Unknown') AS phone_service,
    COALESCE(online_security, 'Unknown') AS online_security,
    COALESCE(tech_support, 'Unknown') AS tech_support,
    COALESCE(paperless_billing, 'Unknown') AS paperless_billing,
    COALESCE(offer, 'None') AS offer
FROM stg_customers;

-- Fact snapshot
CREATE TABLE fact_customer_snapshot AS
SELECT
    c.customer_id,
    COALESCE(c.zip_code, 'UNKNOWN') AS zip_code,
    c.tenure_in_months,
    c.monthly_charge,
    c.total_revenue,
    CASE WHEN LOWER(TRIM(c.customer_status)) LIKE 'churn%' THEN 1 ELSE 0 END AS churn_flag,
    CASE WHEN c.tenure_in_months BETWEEN 0 AND 3 THEN 1 ELSE 0 END AS new_last_quarter,
    CASE WHEN c.monthly_charge >= p.p75 THEN 1 ELSE 0 END AS high_value,
    c.contract,
    c.internet_type,
    c.payment_method,
    c.phone_service,
    c.online_security,
    c.tech_support,
    c.paperless_billing,
    c.offer
FROM stg_customers c
CROSS JOIN (
  SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY monthly_charge) AS p75 FROM stg_customers
) p;

-- Example analytics
-- New customers last quarter
-- SELECT SUM(new_last_quarter) FROM fact_customer_snapshot;
-- Churn rate overall
-- SELECT AVG(churn_flag) FROM fact_customer_snapshot;
-- High-value churn
-- SELECT high_value, AVG(churn_flag) AS churn_rate, COUNT(*) AS n FROM fact_customer_snapshot GROUP BY high_value;
-- Drivers proxy (univariate)
-- SELECT contract, AVG(churn_flag) AS churn_rate FROM fact_customer_snapshot GROUP BY contract ORDER BY churn_rate DESC;
