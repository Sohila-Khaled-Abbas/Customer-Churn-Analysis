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

DROP TABLE IF EXISTS telecom.dim_geo CASCADE;
CREATE TABLE telecom.dim_geo (
  geo_key     SERIAL PRIMARY KEY,
  zip_code    TEXT UNIQUE,
  city        TEXT,
  latitude    NUMERIC,
  longitude   NUMERIC,
  population  INT
);

INSERT INTO telecom.dim_geo (zip_code, city, latitude, longitude, population)
SELECT DISTINCT
  s.zip_code,
  s.city,
  s.latitude,
  s.longitude,
  COALESCE(s.population, z.population) AS population
FROM telecom.stg_fact_customers s
LEFT JOIN telecom.stg_zip_code z
  ON z.zip_code = s.zip_code;

DROP TABLE IF EXISTS telecom.dim_customer CASCADE;
CREATE TABLE telecom.dim_customer (
  customer_id               TEXT PRIMARY KEY,
  gender                    TEXT,
  age                       INT,
  married                   TEXT,
  number_of_dependents      INT,
  number_of_referrals       INT,
  geo_key                   INT REFERENCES telecom.dim_geo(geo_key)
);
  
INSERT INTO telecom.dim_customer (customer_id, gender, age, married, number_of_dependents, number_of_referrals, geo_key)
SELECT DISTINCT
  s.customer_id, s.gender, s.age, s.married, s.number_of_dependents, s.number_of_referrals, g.geo_key
FROM telecom.stg_fact_customers s
JOIN telecom.dim_geo g ON g.zip_code = s.zip_code;

DROP TABLE IF EXISTS telecom.dim_service CASCADE;
CREATE TABLE telecom.dim_service (
  service_key               SERIAL PRIMARY KEY,
  phone_service             TEXT,
  multiple_lines            TEXT,
  internet_service          TEXT,
  internet_type             TEXT,
  online_security           TEXT,
  online_backup             TEXT,
  device_protection_plan    TEXT,
  premium_tech_support      TEXT,
  streaming_tv              TEXT,
  streaming_movies          TEXT,
  streaming_music           TEXT,
  unlimited_data            TEXT,
  contract                  TEXT,
  paperless_billing         TEXT,
  payment_method            TEXT,
  offer                     TEXT
);

-- Populate distinct service bundles
INSERT INTO telecom.dim_service (
  phone_service, multiple_lines, internet_service, internet_type,
  online_security, online_backup, device_protection_plan, premium_tech_support,
  streaming_tv, streaming_movies, streaming_music, unlimited_data,
  contract, paperless_billing, payment_method, offer
)
SELECT DISTINCT
  phone_service, multiple_lines, internet_service, internet_type,
  online_security, online_backup, device_protection_plan, premium_tech_support,
  streaming_tv, streaming_movies, streaming_music, unlimited_data,
  contract, paperless_billing, payment_method, offer
FROM telecom.stg_fact_customers;

CREATE UNIQUE INDEX IF NOT EXISTS ux_dim_service_bundle
ON telecom.dim_service (
  phone_service, multiple_lines, internet_service, internet_type,
  online_security, online_backup, device_protection_plan, premium_tech_support,
  streaming_tv, streaming_movies, streaming_music, unlimited_data,
  contract, paperless_billing, payment_method, offer
);

DROP TABLE IF EXISTS telecom.fact_customer_snapshot;
CREATE TABLE telecom.fact_customer_snapshot (
  customer_id               TEXT REFERENCES telecom.dim_customer(customer_id),
  service_key               INT  REFERENCES telecom.dim_service(service_key),
  geo_key                   INT  REFERENCES telecom.dim_geo(geo_key),
  tenure_in_months          INT,
  monthly_charge            NUMERIC,
  total_charges             NUMERIC,
  total_refunds             NUMERIC,
  total_extra_data_charges  NUMERIC,
  total_long_distance_charges NUMERIC,
  total_revenue             NUMERIC,
  churn_flag                TEXT,
  new_last_quarter          TEXT,
  high_value                TEXT,
  signup_date               DATE,
  signup_quarter            TEXT,
  signup_month              TEXT,
  customer_status           TEXT,
  churn_category            TEXT,
  churn_reason              TEXT
);

-- Compute p75 for monthly_charge (for validation / optional recompute of high_value)
WITH p AS (
  SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY monthly_charge) AS p75
  FROM telecom.stg_fact_customers
),
svc AS (
  SELECT
    s.customer_id,
    d.service_key,
    g.geo_key,
    s.tenure_in_months,
    s.monthly_charge,
    s.total_charges,
    s.total_refunds,
    s.total_extra_data_charges,
    s.total_long_distance_charges,
    s.total_revenue,
    s.churn_flag,
    s.new_last_quarter,
    s.high_value, -- already provided in the file; keep as-is
    s.signup_date,
    s.signup_quarter,
    s.signup_month,
    s.customer_status,
    s.churn_category,
    s.churn_reason
  FROM telecom.stg_fact_customers s
  JOIN telecom.dim_geo g
    ON g.zip_code = s.zip_code
  JOIN telecom.dim_service d
    ON d.phone_service = s.phone_service
   AND d.multiple_lines = s.multiple_lines
   AND d.internet_service = s.internet_service
   AND d.internet_type = s.internet_type
   AND d.online_security = s.online_security
   AND d.online_backup = s.online_backup
   AND d.device_protection_plan = s.device_protection_plan
   AND d.premium_tech_support = s.premium_tech_support
   AND d.streaming_tv = s.streaming_tv
   AND d.streaming_movies = s.streaming_movies
   AND d.streaming_music = s.streaming_music
   AND d.unlimited_data = s.unlimited_data
   AND d.contract = s.contract
   AND d.paperless_billing = s.paperless_billing
   AND d.payment_method = s.payment_method
   AND d.offer = s.offer
)
INSERT INTO telecom.fact_customer_snapshot
SELECT * FROM svc;

CREATE INDEX IF NOT EXISTS ix_fact_churn              ON telecom.fact_customer_snapshot (churn_flag);
CREATE INDEX IF NOT EXISTS ix_fact_signup_month      ON telecom.fact_customer_snapshot (signup_month);
CREATE INDEX IF NOT EXISTS ix_fact_service_key       ON telecom.fact_customer_snapshot (service_key);
CREATE INDEX IF NOT EXISTS ix_fact_geo_key           ON telecom.fact_customer_snapshot (geo_key);
CREATE INDEX IF NOT EXISTS ix_fact_contract          ON telecom.dim_service (contract);


