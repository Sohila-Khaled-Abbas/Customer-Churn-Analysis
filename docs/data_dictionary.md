# **This document defines all the datasets used in the project.**

---

## Dim_Zip_Code

| Column Name | Type | Description         |
| ----------- | ---- | ------------------- |
| zip\_code   | INT  | Zip code identifier |
| city        | TEXT | City name           |
| state       | TEXT | State code          |
| region      | TEXT | Region grouping     |

---

## Fact_Customers

| Column Name  | Type    | Description                      |
| ------------ | ------- | -------------------------------- |
| customer\_id | INT     | Unique customer identifier       |
| join\_date   | DATE    | Date customer joined             |
| churn\_flag  | BOOLEAN | Whether the customer has churned |
| revenue      | DECIMAL | Customer revenue                 |
| zip\_code    | INT     | Foreign key to Dim\_Zip\_Code    |
| """          |         |                                  |
