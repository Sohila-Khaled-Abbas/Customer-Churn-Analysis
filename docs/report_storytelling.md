# Power BI Report Storytelling

## Pages & Purpose
1) **Executive Summary (KPI Hub)**
   - Cards: Customers, Churn Rate, New Customers Last Quarter, High-Value Churn Rate
   - KPI variance (optional) if you load history
   - Slicers: Contract, Internet Type, Payment Method
   - Bookmark: "High-Value Focus" (filter high_value = 1)

2) **Churn Drivers**
   - Column chart: Churn Rate by Contract (mv_churn_by_contract)
   - Bar chart: Churn Rate by Internet Type (mv_churn_by_internet_type)
   - Bar chart: Churn Rate by Payment Method (mv_churn_by_payment_method)
   - Matrix (levers): Online Security x Premium Tech Support (mv_levers_matrix) with Churn Rate

3) **High-Value Retention**
   - KPI: High-Value Customers, HV Churn Rate
   - Table: mv_retention_targets (customer_id, monthly_charge, contract, online_security, premium_tech_support)
   - Button: Export data (Power BI Service)

4) **Onboarding & New Customers**
   - Card: New Customers Last Quarter
   - (If you add signup_date) Cohort heatmap: retention by cohort month
   - Visual showing churn risk by tenure buckets

5) **Geo Lens (ZIP)**
   - Filled map: churn_rate by zip_code (mv_geo_zip)
   - Tooltip: n_customers, churned

## Modeling
- Connect to PostgreSQL (DirectQuery or Import). Suggest **Import** for speed with MVs.
- Tables to load:
  - telecom.fact_customer_snapshot
  - telecom.mv_kpis
  - telecom.mv_churn_by_contract
  - telecom.mv_churn_by_internet_type
  - telecom.mv_churn_by_payment_method
  - telecom.mv_levers_matrix
  - telecom.mv_value_segment
  - telecom.mv_retention_targets
  - telecom.mv_geo_zip

## Interactions & UX
- **Field Parameters**: swap the axis between Contract / Internet Type / Payment Method on the same chart.
- **Bookmarks**:
  - "All Customers" (default)
  - "High-Value Focus"
  - "Contracts vs Add-ons" (shows levers matrix prominent)
- **Drillthrough**: from drivers to “Customer List” with applied filters.
- **Tooltips**: custom tooltip page with micro-cards (n_customers, churn_rate, avg_monthly_charge).
- **Accessibility**: data labels on bars, 12–14pt fonts, high contrast theme.

## DAX Tips
- Add a Date table later if you introduce snapshot_date.
- Use Calculation Groups (Tabular Editor) for % vs Absolute toggles.