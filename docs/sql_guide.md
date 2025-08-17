# 🗄 SQL Schema & Queries
## Staging Tables
- `stg_fact_customers`
- `stg_dim_zip_code`

---

## Star Schema
- Fact: `fact_customers`
- Dimension: `dim_zip_code`

---

## Core Business Queries
### 1. Monthly Churn Rate
```sql
SELECT
    DATE_TRUNC('month', join_date) AS month,
    COUNT(*) FILTER (WHERE churn_flag = TRUE)::FLOAT / COUNT(*) AS churn_rate
FROM fact_customers
GROUP BY 1
ORDER BY 1;
```
### 2. Revenue Lost due to Churn
```sql
SELECT
    SUM(revenue) FILTER (WHERE churn_flag = TRUE) AS churned_revenue,
    SUM(revenue) AS total_revenue,
    (SUM(revenue) FILTER (WHERE churn_flag = TRUE) * 100.0 / SUM(revenue)) AS churn_revenue_pct
FROM fact_customers;
```