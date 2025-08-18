# Telecom Churn Analytics

This project delivers a complete **data analytics pipeline** for a fictional Telecom company, integrating:  

- **PostgreSQL** (staging, star schema, business queries, materialized views)  
- **Power BI** (dashboard storytelling, KPIs, churn analysis)  
- **EDA** (Excel + Python Notebook)  

---

## Workflow Overview

### 1. Data Layer (PostgreSQL)

- Ingest raw data into **staging** (`01_staging_tables.sql`)  
- Transform into **star schema** (`02_star_schema.sql`)  
- Define **business queries** (`03_business_queries.sql`)  
- Create **materialized views** (`04_materialized_views.sql`) for BI  

### 2. Analytics & EDA

- Excel-based churn analysis (`EDA/churn_analysis.xlsx`)  
- Profile customers, churn cohorts, and add-on service impacts  

### 3. BI & Storytelling (Power BI)

- Import data in **Import Mode**  
- Define measures from `docs/measures_dax.txt`  
- Follow `docs/dashboard_storytelling_guide.md` to create narrative-driven dashboards  
- Example visuals: churn KPIs, contract comparison, customer profile segmentation  

### 4. CI/CD

- `.github/deploy-sql.yml` automates schema deployment and refresh  
- Extendable to trigger Power BI Service dataset refresh  

---

## Business Questions Answered

- What is the churn rate overall and by segment?  
- What are the profiles of customers who churn vs. stay vs. join?  
- Which services (online security, tech support) reduce churn risk?  
- Are high-value customers churning more often?  
- Which geographies show higher churn patterns?  

---

## Screenshots

Here are sample visuals from the dashboard and data model.  

### Power BI Dashboard

![Dashboard Overview](images/dashboard_overview.png)

### Customer Churn by Contract

![Churn by Contract](images/churn_by_contract.png)

### Geo Analysis by ZIP Code

![Geo Churn](images/geo_churn.png)

---

## Setup Instructions

### Step 1 — Database

```bash
# Run schema setup
psql -f sql/01_staging_tables.sql
psql -f sql/02_star_schema.sql
psql -f sql/03_business_queries.sql
psql -f sql/04_materialized_views.sql
```

### Step 2 — Data Load

- Import CSVs from `raw_data/` → staging
- Run profiling (`Profile summary aggregation.csv`)

### Step 3 — Power BI

- Open Power BI Desktop → Get Data → PostgreSQL → Import Mode
- Import `fact_customer_snapshot` + materialized views
- Add measures from `docs/measures_dax.txt`
- Build visuals per `docs/report_storytelling.md`

### Step 4 — Exports

- Export dashboards to PDF/CSV for stakeholders
- Curated datasets are already in `cleaned_data/`

---

## Contributing

See [CONTRIBUTING.md](/CONTRIBUTING.md) for guidelines.

---

## License

This repo uses the [LICENSE](/LICENSE) file. Data is fictional and provided for educational/portfolio use.
