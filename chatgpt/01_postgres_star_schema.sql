CREATE SCHEMA IF NOT EXISTS telecom;

DROP TABLE IF EXISTS telecom.stg_fact_customers;

CREATE TABLE telecom.stg_fact_customers (
  customer_id                 TEXT,
  gender                      TEXT,
  age                         INT,
  married                     TEXT,
  number_of_dependents        INT,
  city                        TEXT,
  zip_code                    TEXT,
  latitude                    NUMERIC,
  longitude                   NUMERIC,
  number_of_referrals         INT,
  tenure_in_months            INT,
  offer                       TEXT,
  phone_service               TEXT,
  avg_monthly_long_distance_charges NUMERIC,
  multiple_lines              TEXT,
  internet_service            TEXT,
  internet_type               TEXT,
  avg_monthly_gb_download     NUMERIC,
  online_security             TEXT,
  online_backup               TEXT,
  device_protection_plan      TEXT,
  premium_tech_support        TEXT,
  streaming_tv                TEXT,
  streaming_movies            TEXT,
  streaming_music             TEXT,
  unlimited_data              TEXT,
  contract                    TEXT,
  paperless_billing           TEXT,
  payment_method              TEXT,
  monthly_charge              NUMERIC,
  total_charges               NUMERIC,
  total_refunds               NUMERIC,
  total_extra_data_charges    NUMERIC,
  total_long_distance_charges NUMERIC,
  total_revenue               NUMERIC,
  customer_status             TEXT,
  churn_category              TEXT,
  churn_reason                TEXT,
  churn_flag                  TEXT,
  new_last_quarter            TEXT,
  high_value                  TEXT,
  signup_date                 DATE,
  signup_quarter              TEXT,
  signup_month                TEXT,
  population                  INT
);

DROP TABLE IF EXISTS telecom.stg_zip_code;
CREATE TABLE telecom.stg_zip_code (
  zip_code    TEXT,
  population  INT
);



