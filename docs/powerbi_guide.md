# Power BI Guide — Telecom Churn Analytics

## Live report

[Open the published Telecom Churn dashboard](https://app.powerbi.com/view?r=eyJrIjoiNjEzYjgwOWUtYmQwZC00ODQyLTlmYmQtMTc0NDg3NzFkNDcwIiwidCI6IjI1Y2UwMjYxLWJiZDYtNDljZC1hMWUyLTU0MjYwODg2ZDE1OSJ9).

The PBIX/PBIP report file is not included in this repository. The repository contains the PostgreSQL DDL, datasets, Power BI theme, DAX measure definitions, and dashboard implementation documentation.

## Data loading

Use Power BI Desktop in Import Mode. Connect to the PostgreSQL database and load `telecom.fact_customer_snapshot` plus the materialized views needed for the report. The complete output definitions are in [`sql/04_materialized_views.sql`](../sql/04_materialized_views.sql).

## DAX measures

The current measure definitions are maintained in [`measures_dax.txt`](measures_dax.txt):

- `Customers`
- `Churned Customers`
- `Churn Rate`
- `New Customers Last Quarter`
- `High-Value Customers`
- `High-Value Churn Rate`

## Theme and design documentation

Apply [`power_bi/telecomtheme_new.json`](../power_bi/telecomtheme_new.json) from the Power BI Desktop **View → Themes → Browse for themes** menu.

For layout and interaction guidance, see [`dashboard_storytelling_guide.md`](dashboard_storytelling_guide.md), [`implementation_guide.md`](implementation_guide.md), and [the detailed design guide](Power%20BI%20Dashboard%20Design%20Details_%20Icon,%20Filters,%20Background,%20and%20Navigation.md).
