# **Naming Conventions (camelCase)**

This document outlines the naming conventions used for schemas, tables, views, columns, and other objects in the data warehouse when following the **camelCase** standard.


## **General Principles**


- **Naming Style**: Use camelCase. The first word is lowercase, and each subsequent word starts with an uppercase letter.
    - Examples: `customerInfo`, `salesOrderDetails`, `loadBronzeData`
- **Language**: Use English for all object names.
- **Avoid Reserved Words**: Do not use SQL reserved words as names.
- **Clarity**: Names should be descriptive, meaningful, and business-aligned.


## **Table Naming Conventions**

### **Bronze Rules**

- All tables must start with the source system name, and entity names should match the original source names as closely as possible.
- **`<sourceSystem><Entity>`**
    - `<sourceSystem>`: Name of the source system in lowercase (e.g., `crm`, `erp`).
    - `<Entity>`: Source table name, converted into camelCase.
    - Example: `crmCustomerInfo` → Customer information from the CRM system.


### **Silver Rules**

- Names should still start with the source system, but entities may be **standardized or cleaned** versions of the raw names.
- **`<sourceSystem><Entity>`**
    - Example: `crmCustomer` → Cleaned and standardized customer data from CRM.


### **Gold Rules**

- All gold tables must use **business-aligned** names, starting with a category prefix.
- **`<category><Entity>`**
    - `<category>`: Defines the table role (`dim`, `fact`, `agg`, `report`).
    - `<Entity>`: Business descriptive name in camelCase.

**Examples:**

- `dimCustomer` → Dimension table for customers
- `factSales` → Fact table for sales transactions
- `aggSalesMonthly` → Aggregated monthly sales
- `reportCustomerOrders` → Reporting table for customer orders


## **Column Naming Conventions**

### **Surrogate Keys**

- Primary keys in dimension tables must end with `Key`.
- **`<entity>Key`**
    - Example: `customerKey` in `dimCustomer`

### **Foreign Keys**

- Foreign keys must reuse the **referenced key’s name** for consistency.
    - Example: `customerKey` in `factSales` referencing `dimCustomer.customerKey`.

### **Technical Columns**

- All system-generated metadata columns must start with the prefix `dwh`.
- **`dwh<ColumnName>`**
    - Example:
        - `dwhLoadDate` → Record load date
        - `dwhUpdateDate` → Last updated timestamp
        - `dwhSource` → Source system identifier
        - `dwhBatchId` → Batch load identifier


## **Stored Procedures**

- Stored procedures must follow the format:
- **`load<Layer><Entity>`**
    - `<Layer>`: The layer being loaded (`Bronze`, `Silver`, `Gold`).
    - `<Entity>`: The entity being processed.

**Examples:**

- `loadBronzeCustomerInfo` → Loads raw CRM customer info
- `loadSilverCustomer` → Loads cleaned customer data
- `loadGoldFactSales` → Loads the sales fact table