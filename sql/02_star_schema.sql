-- Drop existing star schema
DROP TABLE IF EXISTS telecom.dim_customer, telecom.dim_location, telecom.fact_customer_activity CASCADE;

-- Dimension Tables
CREATE TABLE telecom.dim_location (
    location_id SERIAL PRIMARY KEY,
    zip_code VARCHAR(10),
	population INT);

INSERT INTO telecom.dim_location (zip_code)
SELECT DISTINCT zip_code
FROM telecom.stg_zip_code;

CREATE TABLE telecom.dim_customer (
    customer_id VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    location_id INT REFERENCES telecom.dim_location(location_id)
);

INSERT INTO telecom.dim_customer
SELECT f.customer_id, f.age, f.gender, l.location_id
FROM telecom.stg_fact_customers f
LEFT JOIN telecom.dim_location l ON f.zip_code = l.zip_code;

-- Fact Table
CREATE TABLE telecom.fact_customer_activity (
    customer_id VARCHAR(100),
    churn_flag TEXT
);

INSERT INTO telecom.fact_customer_activity
SELECT customer_id, churn_flag
FROM telecom.stg_fact_customers;
