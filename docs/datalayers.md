--
## **Data Layers**
--

**Bronze Layer**
Definition:
Raw, unprocessed data as-is from sources

Objective:
Traceability & Debugging

Object Type: Tables
Load Method: Full Load (Truncate & Insert)

Data Transformation: None (as-is)

Data Modeling: None (as-is)

Target Audience:
- Data Engineers

## **Silver Layer**
Definition:
Clean & standardized data

Objective:
Prepare data for analysis

Object Type: Tables
Load Method: Full Load (Truncate & Insert)

Data Transformation:
- Data Cleaning
- Data Standardization
- Data Normalization
- Derived Columns
- Data Enrichment

Data Modeling: None (as-is)
Target Audience:
- Data Engineers
- Data Analysts

## **Gold Layer**
Definition:
Business-Ready data

Objective:
Provide data to be consumed for reporting and analytics

Object Type: Views

Load Method: None

Data Transformation:
- Data Integration
- Data Aggregation
- Business Logic & Rules

Data Modeling:
- Start Schema
- Aggregated Objects
- Flat Tables

Target Audience:
- Data Analysts
- Business Users
