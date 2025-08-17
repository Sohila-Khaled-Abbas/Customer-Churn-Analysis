# Customer Churn Analytics Project – Project Report

## 1. Project Overview
This project focuses on analyzing customer churn using structured data pipelines and Power BI dashboards. The workflow integrates PostgreSQL for data storage, SQL scripts for transformation, and Excel for exploratory analysis (EDA). The final visualization and KPIs are delivered through Power BI.
### Key Objectives:
- Ingest raw data into PostgreSQL.
- Clean & preprocess datasets.
- Design staging + star schema for analytics.
- Run SQL business queries for churn insights.
- Build a Power BI dashboard with DAX measures.

---

## 2. Dataset Description
- Raw Data: Stored in `/raw_data/` (CSV format).
- Cleaned Data: Processed and stored in `/cleaned_data/`.
- EDA: Conducted in Excel (`/EDA/`) for early trend discovery.
### Core Table: Fact_Customers
| Column           | Description                            | Example      |
| ---------------- | -------------------------------------- | ------------ |
| customer\_id     | Unique ID for each customer            | 12345        |
| tenure           | Number of months a customer stayed     | 12           |
| churn\_flag      | Indicates if customer churned          | TRUE / FALSE |
| monthly\_charges | Monthly bill amount                    | 56.75        |
| total\_charges   | Lifetime revenue                       | 678.90       |
| contract\_type   | Contract type (Month-to-Month, Yearly) | Yearly       |

---

## 3. Repo Structure
```graphql
.
├── raw_data/                # Raw CSV files  
├── cleaned_data/            # Cleaned datasets  
├── sql/                     # SQL scripts  
│   ├── 01_staging_tables.sql  
│   ├── 02_star_schema.sql  
│   ├── 03_business_queries.sql  
├── EDA/                     # Excel files for EDA  
├── images/                  # Screenshots for docs/reports  
├── docs/                    # Documentation files  
│   ├── PROJECT_REPORT.md  
│   ├── CONTRIBUTING.md  
│   ├── README.md  
├── .gitignore  
├── LICENSE  
```

---

## 4. Data Pipeline
### 1. Load Cleaned Data into PostgreSQL
- SQL scripts in `/sql/01_staging_tables.sql`.
- Handles proper type casting (`churn_flag` → boolean).
### 2. Schema Design
- `02_star_schema.sql` builds **fact & dimension tables** for BI.
Example Star Schema:
```nginx
Fact_Customers  
  ├── Dim_Contract  
  ├── Dim_Customer  
  ├── Dim_Time  
```
### 3. Business Queries
- SQL insights in `/sql/03_business_queries.sql`.
- Examples:
 -- Churn % by contract type
 -- Average revenue for churned vs retained customers
 -- Monthly churn trend

### 4. Visualization (Power BI)
- Connect to PostgreSQL star schema.
- Create **DAX measures**:
 -- Churn Rate = COUNT(churned) / COUNT(total_customers)
 -- Avg Revenue Loss = SUM(total_charges for churned)

---

## 5. Key Insights (from SQL & Power BI)
✅ Month-to-Month contracts have the highest churn rate.
✅ Customers with higher tenure are less likely to churn.
✅ Revenue impact of churn is significant in early lifecycle customers.

---

##  6. Tools & Technologies
- **Database**: PostgreSQL
- **SQL**: Data ingestion, staging, schema, queries
- **Excel**: EDA and summary analysis
- **Power BI**: Data modeling, DAX, visualization
- **GitHub**: Version control & collaboration

---

## 7. How to Reproduce
1. Clone this repo:
```bash
git clone https://github.com/Sohila-Khaled-Abbas/Customer-Churn-Analysis.git
cd Customer-Churn-Analysis
```
2. Load data into PostgreSQL:
```bash
psql -U username -d database -f sql/01_staging_tables.sql
psql -U username -d database -f sql/02_star_schema.sql
psql -U username -d database -f sql/03_business_queries.sql
```
3. Open Power BI → Connect to PostgreSQL → Import Star Schema Tables.
4. Add **DAX measures** for KPIs.

---

## 8. Future Improvements
- Automate ETL with **Airflow / dbt**.
- Deploy Power BI dashboard with **Row-Level Security (RLS)**.
- Add predictive churn model (ML).

---

## 9. License
This project is licensed under the **MIT License** – see [LICENSE](/LICENSE).

