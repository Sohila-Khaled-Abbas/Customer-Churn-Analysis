# 📊 Power BI Report Guide
## Data Model
- Import `fact_customers` and `dim_zip_code`
- Define relationship: `fact_customers.zip_code` = `dim_zip_code.zip_code`

---

## DAX Measures
```DAX
Churn Rate = DIVIDE(CALCULATE(COUNTROWS(fact_customers), fact_customers[churn_flag] = TRUE), COUNTROWS(fact_customers))

Retention Rate = 1 - [Churn Rate]

Total Revenue = SUM(fact_customers[revenue])

Churned Revenue = CALCULATE(SUM(fact_customers[revenue]), fact_customers[churn_flag] = TRUE)
```
