/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dimCustomer
-- =============================================================================

--SELECT "cstId", COUNT(*) FROM(
CREATE VIEW Gold."dimCustomer" AS
SELECT 
	row_number() over (order by "cstId") AS "customerKey",
	ci."cstId" AS "customerId",
	ci."cstKey" AS "customerNumber",
	ci."cstFirstName" AS "firstName",
	ci."cstLastName" AS "lastName",
	ca."bDate" AS "brithDate",
	ci."cstMaritalStatus" AS "maritalStatus",
	CASE WHEN ci."cstGndr" != 'n/a' THEN ci."cstGndr" --CRM is the master fro gender Info
		 WHEN TRIM(ca."gen") IN ('FEMALE', 'Female') THEN 'Female'
		 WHEN TRIM(ca."gen") IN ('MALE', 'Male') THEN 'Male'	
		 ELSE COALESCE (ca."gen", 'n/a')
	END AS "gender",
	la."cntry" AS "country",
	ci."cstCreateDate" AS "createDate"
	
FROM silver."crmCustInfo" ci
LEFT JOIN silver."erpCustAz12" ca
ON 		ci."cstKey" = ca."cId"
LEFT JOIN silver."erpLocA101" la
ON      ci."cstKey" = la."cId"
--)t GROUP BY "cstId"
--HAVING COUNT(*) > 1

-- =============================================================================
-- Create Dimension: gold.dimProducts
-- =============================================================================

--SELECT "prdKey", count(*) from(
CREATE VIEW Gold."dimProducts" AS
SELECT 
	row_number() over(order by pn."prdStartDt", pn."prdKey") AS "productKey",
	pn."prdId" AS "productId",
	pn."prdKey" AS "productNumber",
	pn."prdNm" AS "productName",
	pn."cstId" AS "categoryId",
	pc."cat" AS "category",
	pc."subCat" AS "subCategory",
	pc."maintenance",
	pn."prdCost" AS "productCost",
	pn."prdLine" AS "productLine",
	pn."prdStartDt" AS "productStartDate"
FROM silver."crmPrdInfo" pn
LEFT JOIN silver."erpPxCatG1V2" pc
ON pn."cstId" = pc."id"
WHERE "prdEndDt" is NULL -- filter out all the historical data
--)t Group by "prdKey"
--Having count(*) > 1

-- =============================================================================
-- Create Dimension: gold.factSales
-- =============================================================================

CREATE VIEW gold."factSales" AS
SELECT
	sd."slsOrdNum" AS "orderNumber",
	pr."productKey",
	cu."customerKey",
	sd."slsOrderDt" AS "orderDate",
	sd."slsShipDt" AS "shippingDate",
	sd."slsDueDt" AS "dueDate",
	sd."slsSales" AS "salesAmount",
	sd."slsQuantity" AS "Quantity",
	sd."slsPrice" AS "price"
FROM silver."crmSalesDetails" sd
LEFT JOIN gold."dimProducts" pr
ON sd."slsPrdKey" = pr."productNumber"
LEFT JOIN gold."dimCustomer" cu
ON sd."slsCustId" = cu."customerId"




