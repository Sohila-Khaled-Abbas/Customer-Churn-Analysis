-- Drop existing star schema
DROP TABLE IF EXISTS dim_customer, dim_location, fact_customer_activity CASCADE;

-- Dimension Tables
CREATE TABLE dim_location (
    location_id SERIAL PRIMARY KEY,
    zip_code VARCHAR(10),
    city VARCHAR(100),
    state VARCHAR(50),
    region VARCHAR(50)
);

INSERT INTO dim_location (zip_code, city, state, region)
SELECT DISTINCT zip_code, city, state, region
FROM stg_dim_zip_code;

CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    location_id INT REFERENCES dim_location(location_id),
    join_date DATE
);

INSERT INTO dim_customer
SELECT f.customer_id, f.name, f.age, f.gender, l.location_id, f.join_date
FROM stg_fact_customers f
LEFT JOIN dim_location l ON f.zip_code = l.zip_code;

-- Fact Table
CREATE TABLE fact_customer_activity (
    customer_id INT REFERENCES dim_customer(customer_id),
    churn_flag BOOLEAN,
    PRIMARY KEY (customer_id)
);

INSERT INTO fact_customer_activity
SELECT customer_id, churn_flag
FROM stg_fact_customers;
