# Power BI Dashboard Design Details: Icon, Filters, Background, and Navigation

This document provides detailed guidance on implementing specific design elements observed in the reference dashboard image, including the telecom business icon, filter placement, dashboard background, and page navigation.

## 1. Telecom Business Icon

To integrate the generated telecom business icon (`telecom_icon.png`) into your Power BI dashboard, you can typically place it in the top-left corner of your report, similar to the "NexaVerse" logo in the reference image. This icon serves as a branding element and can also be used as a button to navigate to a home page or reset filters.

**Implementation Steps:**

1.  **Insert Image:** In Power BI Desktop, go to the **Insert** tab in the ribbon.
2.  **Select Image:** Click on **Image** and browse to the location where you saved `telecom_icon.png` (e.g., `/home/ubuntu/telecom_icon.png`). Select the image and click **Open**.
3.  **Position and Size:** Drag and resize the image to fit the desired location in the top-left corner of your dashboard. Ensure it is appropriately sized to be visible but not overpowering.
4.  **Optional: Add Action:** You can add an action to the image, such as 

a "Back" action to return to a previous page, or a "Bookmark" action to reset all filters to a default view.

## 2. Filter Placement (Slicers)

The reference image shows vertical slicers on the left side of the dashboard. This is a common and effective layout for providing intuitive filtering options without consuming too much horizontal space. For your telecom churn dashboard, the request specifies vertical slicers for `Contract`, `Internet Type`, `Payment Method`, and `High Value (0/1)`.

**Implementation Steps:**

1.  **Add Slicers:** For each field you want to filter (`Contract`, `Internet Type`, `Payment Method`, `High Value`), drag the field from the **Fields** pane onto your report canvas. Power BI will automatically create a slicer visual.
2.  **Convert to List (if not already):** By default, slicers might appear as a dropdown. To match the reference image, ensure they are set to a "List" orientation. Select the slicer, go to the **Format your visual** pane, and under **Slicer settings** > **Options** > **Orientation**, choose **Vertical list**.
3.  **Position Vertically:** Arrange all slicers vertically along the left side of your dashboard. Ensure there is consistent padding between them and that they align neatly.
4.  **Formatting:**
    *   **Selection Controls:** Under **Slicer settings** > **Selection**, you can enable "Single select" if you want users to select only one option at a time, or "Show 'Select all' option" for convenience.
    *   **Search Box:** For slicers with many options (e.g., `Payment Method`), consider enabling the "Search" option under **Slicer settings** to allow users to quickly find specific values.
    *   **Header:** Customize the slicer header (e.g., font, color) to match your dashboard's theme. The theme file (`telecomtheme_new.json`) will help with this.
    *   **Background:** Set the background of the slicer visuals to be transparent or match the background of the left navigation pane to create a seamless look.

## 3. Dashboard Background and Layout

The reference image features a distinct two-tone background: a darker green for the left navigation pane and a lighter, almost white, background for the main content area. This creates a clear visual separation and hierarchy.

**Implementation Steps:**

1.  **Page Background:**
    *   Select an empty area on your report canvas (ensure no visual is selected).
    *   Go to the **Format your report page** pane.
    *   Under **Canvas background**, set the color to a light grey or off-white (`#F2F2F2` as defined in `telecomtheme_new.json` for `page` background). You can also set the transparency to 0%.
2.  **Left Navigation Pane:**
    *   To create the distinct left navigation area, you can use a **Shape** visual (e.g., a rectangle).
    *   Go to the **Insert** tab > **Shapes** > **Rectangle**.
    *   Position this rectangle on the left side of your page, covering the area where your slicers and navigation elements will reside.
    *   Go to the **Format shape** pane. Under **Fill**, set the color to the darker green (`#4B6C37` as defined in `telecomtheme_new.json` for `outspacePane` background). Set transparency to 0%.
    *   Under **Border** and **Shadow**, you can disable them to achieve a clean look.
    *   **Send to Back:** Right-click on the shape, select **Order**, and then **Send to back**. This ensures that your slicers, icons, and text elements placed on top of this shape are visible.
3.  **Visual Backgrounds:** The individual cards and charts in the main content area have a white background with rounded corners. This is handled by the `telecomtheme_new.json` file, which sets the `background` for `*` (all visuals) to white. You may need to adjust individual visual settings for rounded corners if the theme doesn't apply it automatically (this is typically a visual-specific setting under **Format your visual** > **General** > **Effects** > **Visual border** > **Rounded Corners**).

## 4. Page Navigation

The reference image displays a vertical navigation bar on the left, with icons and text labels for different dashboard pages (Overview, Transactions, Customers, Reports, Settings, Developer). This provides a user-friendly way to navigate between the different sections of your report.

**Implementation Steps:**

1.  **Create Pages:** Ensure you have separate pages in your Power BI report for each section (e.g., "Executive Summary", "Churn Drivers", "High-Value Retention", "Onboarding", "Geo"). You can rename them to match the navigation labels if desired.
2.  **Use Buttons for Navigation:**
    *   Go to the **Insert** tab > **Buttons**.
    *   You can choose a blank button or one with an icon. For the look in the reference image, you'll likely use blank buttons and then add icons and text boxes on top of them, or use the built-in icon options.
    *   **Add Icons:** For each navigation item, you'll need appropriate icons. Power BI has a built-in icon library, or you can import custom icons (e.g., SVG files for scalability). Place the icon on the button.
    *   **Add Text:** Use a **Text box** visual on top of each button to add the page name (e.g., "Overview", "Customers"). Format the text to match the theme's font and color for navigation elements.
    *   **Group Elements:** Select the button, icon, and text box for each navigation item, right-click, and select **Group** > **Group**. This makes it easier to move and manage them.
3.  **Assign Page Navigation Action:**
    *   Select a grouped navigation item (button).
    *   Go to the **Format button** pane.
    *   Under **Action**, turn it **On**.
    *   Set **Type** to **Page navigation**.
    *   For **Destination**, select the corresponding page (e.g., for the "Customers" button, select the "Customers" page).
4.  **Position and Duplicate:** Position the first navigation item within the left green rectangle. Once you have one styled correctly, you can copy and paste it to create the others, then just change the icon, text, and action destination for each.
5.  **Page Navigator Visual (Alternative):** Power BI also offers a "Page navigator" visual (under **Buttons** > **Navigator**). While it might not give you the exact icon-and-text layout as precisely as individual buttons, it automates the creation of navigation buttons for all your report pages. You can then format it to closely match the desired look. This is often a more efficient approach for managing many pages.

By following these detailed steps, you should be able to replicate the visual style and navigation elements of the reference dashboard image in your Power BI report, creating a professional and user-friendly experience for your telecom churn analysis.

