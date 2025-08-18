# Contributing Guidelines

> Thank you for your interest in contributing to the **Telecom Customer Churn Analysis Project**!
>
> This project combines **SQL-based data modeling** and **Power BI dashboards** to deliver actionable insights.
>
> To maintain quality and consistency, please follow the guidelines below.

---

## Project Workflow

1. **Fork the repository** → make your changes in a feature branch.
2. **Commit using clear messages** (see style guide below).
3. **Open a Pull Request (PR**) → link the related issue, describe your changes, and attach screenshots for Power BI updates.
4. **Code review required** → at least one reviewer approval before merge.

---

## SQL Style Guide

- **File Naming**: use `snake_case` for SQL files, e.g., `customer_churn_model.sql`.
- **Schema**: group objects logically (e.g., `staging`, `analytics`, `reporting`).
- **CTEs**:
 -- Always use CTEs for readability instead of nested subqueries.
 -- Name CTEs descriptively (`churned_customers_cte`, `monthly_revenue_cte`).
- **Joins**:
 -- Use explicit `INNER JOIN`, `LEFT JOIN` (avoid implicit joins).
 -- Align `ON` conditions vertically for clarity.
- **Aliases**:
 -- Short, lowercase aliases (e.g., `c` for `customers`, `t` for `transactions`).
- **Keywords**:
 -- Always UPPERCASE SQL keywords (`SELECT`, `JOIN`, `GROUP BY`).
- **Comments**:
 -- Use `--` for single-line, `/* ... */` for block comments.
 -- Explain complex logic (esp. churn metrics like retention windows).

---

## Power BI Style Guide

### Data Model Naming

- **Tables**: dim_Customer, fact_Transactions, fact_Churn.
- **Measures**: prefix with category → (Revenue_Total, Churn_Rate, Retention_Rate).
- **Columns**: PascalCase (e.g., CustomerID, JoinDate).

### Visuals & Layout

- Keep dashboards **story-driven**:

1. **Overview Page** → high-level churn KPIs.
2. **Trend Page** → churn over time.
3. **Segmentation Page** → churn by customer segments.
4. **Deep Dive** → predictive models, drill-throughs.

- Use consistent color palette:
 -- **Red** → churned customers.
 -- **Green** → retained customers.
 -- **Blue** → neutral/overall KPIs.

- Add tooltips and annotations to explain “why” not just “what.”

### DAX Best Practices

- Avoid calculated columns when a measure suffices.
- Use variables (`VAR`) for readability and performance.
- Document complex measures in comments.

---

## Pull Request Workflow

### Branch Naming

 `feature/<short-description>` or `fix/<short-description>`
 Example: `feature/add_churn_rate_measure`

### Commit Messages

- Format: `[component]`: short description
- Example:
 -- `SQL: Add churned_customers_cte for monthly model`
 -- `PowerBI: Update churn dashboard layout`

### PR Checklist

- [ ] Code follows SQL + Power BI style guides.
- [ ] Documentation updated (README, comments).
- [ ] Screenshots of new dashboards/visuals attached.
- [ ] Tests (where applicable) included

---

## Resources

- [dbt SQL Style Guide](https://docs.getdbt.com/docs/collaborate/git/style-guide)
- [Microsoft Power BI Naming Conventions](https://learn.microsoft.com/en-us/power-bi/guidance/naming-conventions)
- [Analytics Engineering Best Practices](https://www.locallyoptimistic.com/)
