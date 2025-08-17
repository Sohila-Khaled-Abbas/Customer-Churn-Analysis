-- Drop if exists
DROP TABLE IF EXISTS stg_fact_customers;
DROP TABLE IF EXISTS stg_dim_zip_code;

-- Staging Tables
CREATE TABLE stg_dim_zip_code (
    zip_code VARCHAR(10) PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE stg_fact_customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    zip_code VARCHAR(10),
    join_date DATE,
    churn_flag BOOLEAN
);

-- Load Data (adjust file paths if needed)
COPY stg_dim_zip_code
FROM '/path/to/cleaned_data/Dim_Zip_Code.csv'
DELIMITER ',' CSV HEADER;

COPY stg_fact_customers
FROM '/path/to/cleaned_data/Fact_Customers.csv'
DELIMITER ',' CSV HEADER;
