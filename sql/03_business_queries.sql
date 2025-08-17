-- 1. Customer churn rate
SELECT 
    ROUND(100.0 * SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM fact_customer_activity;

-- 2. Customers by region
SELECT 
    l.region,
    COUNT(c.customer_id) AS total_customers
FROM dim_customer c
JOIN dim_location l ON c.location_id = l.location_id
GROUP BY l.region
ORDER BY total_customers DESC;

-- 3. Average age of churned vs active customers
SELECT 
    f.churn_flag,
    ROUND(AVG(c.age), 1) AS avg_age
FROM fact_customer_activity f
JOIN dim_customer c ON f.customer_id = c.customer_id
GROUP BY f.churn_flag;

-- 4. Gender distribution
SELECT 
    c.gender,
    COUNT(*) AS customer_count
FROM dim_customer c
GROUP BY c.gender;
