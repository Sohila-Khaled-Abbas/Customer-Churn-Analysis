-- =============================================
-- Logistic Regression with MADlib (Optional)
-- Requires: CREATE EXTENSION madlib;
-- =============================================
SET search_path TO telecom, public;

-- 1) Prepare feature table (one row per customer)
DROP TABLE IF EXISTS churn_features;
CREATE TABLE churn_features AS
SELECT
  f.customer_id,
  f.churn_flag::INT AS label,
  -- numeric features
  COALESCE(f.tenure_in_months,0)::FLOAT8 AS tenure,
  COALESCE(f.monthly_charge,0)::FLOAT8 AS monthly_charge,
  COALESCE(f.total_charges,0)::FLOAT8 AS total_charges,
  COALESCE(f.total_refunds,0)::FLOAT8 AS total_refunds,
  COALESCE(f.total_extra_data_charges,0)::FLOAT8 AS extra_data_charges,
  COALESCE(f.total_long_distance_charges,0)::FLOAT8 AS ldist_charges,
  COALESCE(dc.number_of_referrals,0)::FLOAT8 AS referrals,
  COALESCE(dc.age,0)::FLOAT8 AS age,
  COALESCE(dc.number_of_dependents,0)::FLOAT8 AS dependents,
  -- categorical dummies (examples)
  (CASE WHEN ds.contract = 'Month-to-month' THEN 1 ELSE 0 END)::FLOAT8 AS contract_m2m,
  (CASE WHEN ds.contract = 'One year' THEN 1 ELSE 0 END)::FLOAT8 AS contract_1y,
  (CASE WHEN ds.internet_type = 'Fiber Optic' THEN 1 ELSE 0 END)::FLOAT8 AS inet_fiber,
  (CASE WHEN ds.internet_type = 'DSL' THEN 1 ELSE 0 END)::FLOAT8 AS inet_dsl,
  (CASE WHEN ds.payment_method = 'Mailed Check' THEN 1 ELSE 0 END)::FLOAT8 AS pay_check,
  (CASE WHEN ds.payment_method LIKE 'Credit Card%%' THEN 1 ELSE 0 END)::FLOAT8 AS pay_cc,
  (CASE WHEN ds.online_security = 'Yes' THEN 1 ELSE 0 END)::FLOAT8 AS sec_yes,
  (CASE WHEN ds.premium_tech_support = 'Yes' THEN 1 ELSE 0 END)::FLOAT8 AS tech_yes,
  (CASE WHEN ds.paperless_billing = 'Yes' THEN 1 ELSE 0 END)::FLOAT8 AS paperless_yes,
  (CASE WHEN ds.phone_service = 'Yes' THEN 1 ELSE 0 END)::FLOAT8 AS phone_yes,
  (CASE WHEN ds.streaming_tv = 'Yes' THEN 1 ELSE 0 END)::FLOAT8 AS stv_yes
FROM fact_customer_snapshot f
JOIN dim_service ds USING (service_key)
JOIN dim_customer dc USING (customer_id);

-- 2) Build feature ARRAY column for MADlib
ALTER TABLE churn_features ADD COLUMN features FLOAT8[];
UPDATE churn_features SET features = ARRAY[
  tenure, monthly_charge, total_charges, total_refunds, extra_data_charges, ldist_charges,
  referrals, age, dependents,
  contract_m2m, contract_1y,
  inet_fiber, inet_dsl,
  pay_check, pay_cc,
  sec_yes, tech_yes, paperless_yes, phone_yes, stv_yes
];

-- 3) Train logistic regression
CREATE EXTENSION IF NOT EXISTS madlib;
DROP TABLE IF EXISTS churn_logregr_model, churn_logregr_summary;
SELECT madlib.logregr_train(
  'churn_features',        -- source
  'churn_logregr_model',   -- out model table
  'label',                 -- dependent var
  'features',              -- independent var array
  NULL,                    -- grouping
  20,                      -- max iterations
  'irls',                  -- optimizer
  1e-6                     -- tolerance
);

-- 4) Score & performance
DROP TABLE IF EXISTS churn_scored;
CREATE TABLE churn_scored AS
SELECT f.customer_id,
       m.coef, m.intercept,
       madlib.logregr_predict_prob(m.coef, m.intercept, f.features) AS churn_prob,
       f.label
FROM churn_features f, churn_logregr_model m;

-- Example: Top at-risk high-value customers
SELECT s.customer_id, s.churn_prob
FROM churn_scored s
JOIN fact_customer_snapshot f USING (customer_id)
WHERE f.high_value = 1
ORDER BY churn_prob DESC
LIMIT 100;

-- Coefficients (bigger + means higher churn risk)
SELECT generate_subscripts(coef, 1) AS idx, coef[idx] AS beta
FROM churn_logregr_model
ORDER BY idx;
