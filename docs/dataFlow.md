# Data Catalog with Lineage Context (camelCase)

---

## Bronze Layer (Raw Ingested Data)

* **crmSalesDetails** → Raw sales transactions from CRM.
* **crmCustInfo** → Raw customer information from CRM.
* **crmPrdInfo** → Raw product information from CRM.
* **erpCustAz12** → Customer master extension from ERP (birthDate, gender).
* **erpLocA101** → Customer location details from ERP.
* **erpPxCatG1v2** → Product category mapping from ERP.

**Bronze = raw, no cleaning, as-is from source.**

---

## ⚪ Silver Layer (Cleaned, Standardized Data)

* **crmSalesDetails** → Cleaned sales with validated sales amount, corrected dates.
* **crmCustInfo** → Standardized customers (names, gender, marital status).
* **crmPrdInfo** → Products with valid dates (`prdStartDt`, `prdEndDt`), cost, and categories.
* **erpCustAz12** → Normalized IDs, fixed gender and birthDates.
* **erpLocA101** → Standardized country names.
* **erpPxCatG1v2** → Cleaned product categories (no trailing spaces).

**Silver = data quality fixes, consistency, ready for business use.**

---

## Gold Layer (Business Models / Analytics Ready)

* **factSales**

  * **Grain:** Sales transaction (order line).
  * **Derived from:** `crmSalesDetails`.
  * **Measures:** sales, quantity, price.
  * **Dimensions:** customer, product, date.

* **dimCustomers**

  * **Derived from:** `crmCustInfo` + `erpCustAz12` + `erpLocA101`.
  * **Attributes:** demographics (gender, birthDate), location (country), marital status.

* **dimProducts**

  * **Derived from:** `crmPrdInfo` + `erpPxCatG1v2`.
  * **Attributes:** productName, category, subCategory, cost, productLine.

**Gold = star schema, optimized for BI/reporting.**

---

this into a **column-level data dictionary** (like `slsOrdNum`, `cstId`, `prdKey`) so the catalog covers both **table lineage** and **field-level definitions**?
