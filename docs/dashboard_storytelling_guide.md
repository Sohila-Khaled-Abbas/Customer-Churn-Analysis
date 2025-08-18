# Power BI Dashboard Storytelling Guide: Telecom Churn Analysis

This guide outlines the storytelling narrative, layout, and visual choices for each page of the Telecom Churn Analysis Power BI dashboard. The goal is to create a data-driven narrative that empowers stakeholders to understand, analyze, and act upon customer churn insights.

## General Design Principles

Following the design tips provided, the dashboard will adhere to a 12-column grid system for consistent layout, generous padding between visuals for readability, and a maximum of two primary colors (with shades) to maintain a clean and impactful aesthetic. Key performance indicators (KPIs) and important numbers will be prominently displayed with large font sizes to immediately draw attention to critical metrics.

## Page 1: Executive Summary (Board-Friendly)

**Narrative:** This page serves as a high-level overview for executive stakeholders, providing immediate insights into the current state of customer churn and its financial implications. The focus is on clarity, conciseness, and actionable metrics that can inform strategic decisions.

**Layout & Visuals:**

*   **Cards (Top Row):**
    *   **Customers:** Displays the total number of customers, providing context for the churn rates.
    *   **Churn Rate (format 0.0%):** Shows the overall churn rate, a critical top-line metric.
    *   **High-Value Churn Rate:** Highlights the churn rate specifically for high-value customers, emphasizing a key area of concern.
    *   **New Customers (Last Qtr):** Indicates recent customer acquisition, balancing the churn narrative.
    *   *Storytelling Purpose:* These cards provide a quick, at-a-glance understanding of the current customer landscape, immediately highlighting the magnitude of churn and the impact on valuable segments.

*   **Clustered Column Chart: Churn Rate by Contract (Field Parameter lets you switch to Internet Type / Payment)**
    *   *Storytelling Purpose:* This visual allows executives to quickly identify which contract types, internet types, or payment methods are most susceptible to churn. The field parameter adds flexibility for deeper initial exploration without cluttering the dashboard.

*   **KPI: Revenue at Risk (Actual Churn) with trend (if you add dates later)**
    *   *Storytelling Purpose:* Translates churn into a tangible financial impact, making the problem more concrete for business leaders. The trend (when dates are available) will show whether this risk is increasing or decreasing over time, indicating the effectiveness of retention efforts.

*   **Slicers (Vertical, Left): Contract, Internet Type, Payment Method, High Value (0/1)**
    *   *Storytelling Purpose:* Positioned vertically on the left, these slicers provide intuitive filtering options, allowing executives to drill down into specific segments and understand how churn varies across different customer attributes. The 'High Value' slicer is crucial for focusing on the most impactful customer group.

*   **Bookmark: “High-Value Focus” (HV=1 filter on)**
    *   *Storytelling Purpose:* This bookmark provides a one-click shortcut to filter the entire dashboard for high-value customers, enabling rapid analysis of this critical segment and supporting the narrative of prioritizing high-value retention.

*   **Interactions:** Disable cross-filtering on cards to prevent 


jittery behavior, as specified in the design tips. Charts should highlight the table on the HV Retention page.

## Page 2: Churn Drivers

**Narrative:** This page delves deeper into the root causes of churn, providing granular insights into which specific attributes or behaviors are most strongly correlated with customers leaving. The visuals are designed to facilitate direct comparison and identification of key problem areas.

**Layout & Visuals:**

*   **Column Chart: Churn Rate by Contract**
    *   *Storytelling Purpose:* Visually emphasizes the churn rate across different contract types, making it easy to spot the highest-risk contracts (e.g., Month-to-Month).

*   **Column Chart: Churn Rate by Internet Type**
    *   *Storytelling Purpose:* Identifies internet service types with elevated churn, guiding efforts to improve service quality or address specific issues for those segments.

*   **Column Chart: Churn Rate by Payment Method**
    *   *Storytelling Purpose:* Highlights payment methods associated with higher churn, potentially indicating issues with billing processes or customer convenience.

*   **Matrix (from mv_levers_matrix.csv): Online Security × Premium Tech Support with churn_rate**
    *   *Storytelling Purpose:* This crucial visual reveals the combined impact of online security and premium tech support on churn. It allows for the identification of customer segments that lack these services and exhibit significantly higher churn rates, pointing to potential 


levers for retention. The data screaming section already highlighted this as a material impact area.

*   **Tooltip page: micro-cards for n_customers, churn_rate, avg monthly_charge (if you add it)**
    *   *Storytelling Purpose:* Provides quick, detailed context when hovering over data points in the churn driver charts, allowing for deeper exploration without navigating away from the page. This helps in understanding the scale of the churn problem within specific segments.

## Page 3: High-Value Retention

**Narrative:** This page focuses specifically on the retention of high-value customers, recognizing their disproportionate impact on revenue. It aims to identify individual high-value customers at risk and provide actionable insights for targeted retention efforts.

**Layout & Visuals:**

*   **Card: High-Value Churn Rate**
    *   *Storytelling Purpose:* Re-emphasizes the critical metric of high-value churn, keeping it top of mind for users focused on this segment.

*   **Table: mv_retention_targets.csv (top N by monthly_charge) with columns: customer_id, monthly_charge, contract, internet_type, payment_method, online_security, premium_tech_support, paperless_billing**
    *   *Storytelling Purpose:* This table provides a direct list of high-value customers who are most at risk (or top N by monthly charge), along with key attributes that can inform personalized retention strategies. It’s designed to be actionable for sales or customer success teams.

*   **Button: Export data (from Service) → hand to Sales Ops**
    *   *Storytelling Purpose:* Facilitates direct action by allowing users to export the list of at-risk high-value customers, enabling seamless integration with operational workflows for outreach and intervention.

## Page 4: Onboarding

**Narrative:** This page shifts focus to the initial customer journey, analyzing churn patterns among new customers. Understanding churn during the onboarding phase is crucial for improving early customer experience and long-term retention.

**Layout & Visuals:**

*   **Cards: New Customers (Last Qtr)**
    *   *Storytelling Purpose:* Provides a clear metric of recent customer acquisition, setting the context for analyzing early-stage churn.

*   **Column: Churn Rate by tenure_in_months band (0–3, 4–12, 13–24, 24+)**
    *   *Storytelling Purpose:* This visual helps identify critical periods in a customer's lifecycle where churn is most prevalent. It allows for targeted interventions based on how long a customer has been with the service.

*   **If you later add signup_date, add a cohort heatmap (tenure vs month-since-signup)**
    *   *Storytelling Purpose:* (Future Enhancement) A cohort heatmap would provide a powerful visual representation of churn trends over time for different customer acquisition groups, offering deeper insights into the effectiveness of onboarding and early retention strategies.

## Page 5: Geo

**Narrative:** This page provides a geographical perspective on churn, identifying regions or zip codes with higher churn rates. This can inform localized marketing efforts, service improvements, or resource allocation.

**Layout & Visuals:**

*   **Filled map: zip_code with churn_rate (color) and n_customers (size)**
    *   *Storytelling Purpose:* Visually represents churn hotspots across different geographical areas. The color intensity indicates churn rate, while the size of the bubble or area indicates the number of customers, providing a dual perspective on impact.

*   **Tooltip: small table with churn_rate, n_customers, avg monthly_charge**
    *   *Storytelling Purpose:* Offers detailed information for specific geographical areas upon hover, allowing users to quickly understand the churn characteristics of a particular region.

## Design Tips Implementation

*   **12-column grid, generous padding:** The layout for each page will adhere to a 12-column grid, ensuring visual balance and organization. Generous padding will be applied around all visuals to improve readability and reduce visual clutter.
*   **2 colors max, big numbers:** The enhanced theme (`telecomtheme_new.json`) has been designed with a primary color palette derived from the provided image, focusing on a maximum of two main colors (green and a complementary accent color, with shades) to maintain a clean and professional look. KPIs and card values will utilize large font sizes for immediate impact.
*   **Set interactions:**
    *   **Charts highlight the table on HV Retention:** When a user selects a data point on a chart (e.g., Churn Rate by Contract), the corresponding rows in the high-value retention table will be highlighted, enabling cross-analysis.
    *   **On Exec Summary, disable cross-filter that makes cards jittery:** As specified, cross-filtering will be disabled for the cards on the Executive Summary page to ensure a stable and clear display of key metrics, preventing unintended visual disturbances during interaction.

This comprehensive guide, combined with the `telecomtheme_new.json` file, provides a robust framework for building a data-driven Power BI dashboard that effectively communicates insights into telecom customer churn.

