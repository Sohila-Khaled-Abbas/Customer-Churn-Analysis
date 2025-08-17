# Customer Churn Analysis

## 📌 Project Overview
This project is an **end-to-end data analytics pipeline** designed to answer critical business questions about **customer churn**.  
It covers:
- Data cleaning & staging in PostgreSQL
- Building a **Star Schema** for analysis
- Writing SQL queries for business insights
- Modeling churn drivers with SQL logic
- Building an **interactive Power BI dashboard**

---

## 📂 Project Structure
- **raw_data/** → Original CSV datasets  
- **cleaned_data/** → Pre-processed datasets (ready for SQL load)  
- **sql/** → SQL DDL, star schema build, queries, and churn modeling  
- **EDA/** → Exploratory data analysis in Excel  
- **docs/** → Documentation, data dictionary, and report exports  
- **images/** → Dashboard screenshots  

---

## ⚙️ Tech Stack
- **PostgreSQL** (Data warehouse + SQL queries)
- **Excel** (EDA, quick stats)
- **Power BI** (Data modeling & dashboard visualization)
- **GitHub** (Version control & collaboration)

---

## 🔑 Business Questions Answered
1. What is the **overall churn rate**?  
2. Which **demographics (age, gender, zip codes)** are most churn-prone?  
3. How does **contract type / tenure / services used** affect churn?  
4. What are the **top churn drivers** modeled in SQL?  

---

## 📊 Power BI Dashboard
- **Page 1 (KPIs Overview)**  
   - Churn Rate %  
   - Total Customers  
   - Active vs. Churned Customers  
   - Average Tenure  

- **Page 2 (Churn Drivers)**  
   - Churn segmented by age group, contract type, and region  
   - Advanced visuals (decomposition tree, scatter plots)  

📷 Example Screenshots:  
![Dashboard Overview](images/pbix_overview.png)  
![Churn Drivers](images/churn_drivers.png)  

---

## 🚀 How to Run
1. Load cleaned datasets into PostgreSQL using scripts in `sql/`.  
2. Build **staging + star schema** with `01_staging_tables.sql` & `02_star_schema.sql`.  
3. Run `03_business_queries.sql` for insights.  
4. Open Power BI → Connect to PostgreSQL → Import `star schema tables`.  
5. Add measures (DAX) for KPIs.  

---

## 📖 Documentation
- [Data Dictionary](docs/data_dictionary.md)  
- [SQL Schema Guide](docs/sql_guide.md)  
- [Power BI Report Guide](docs/powerbi_guide.md)
- [Power BI Report (PDF)](docs/powerbi_report.pdf)  

---

## 🏆 Key Learnings
- How to model a **churn dataset** with SQL (star schema + driver modeling).  
- Designing an **analytics-ready pipeline** (staging → fact/dim → BI).  
- Communicating churn insights visually in **Power BI**.  

---

## 👩‍💻 Author
**Sohila Khaled Galal Abbas**  
[LinkedIn](https://www.linkedin.com/in/sohilakabbas/)
*Data Analyst* | *BI Developer* | *Power BI Enthusiast*
