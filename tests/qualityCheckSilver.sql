--=================================================
--CHECKING silver."crmCustInfo"
--=================================================
--check for nulls or duplicates in primary key
--expectation : no result
select  
	"cstId",
	count (*) AS duplicateCount
	from silver."crmCustInfo"
group by "cstId"
having count(*) > 1 or "cstId" is NULL;

--check for umwanted spaces
-- expectation : no results
select "cstLastName"
from silver."crmCustInfo"
WHERE "cstLastName" != TRIM("cstLastName")

-- check for distinct values
select  DISTINCT "cstGndr"
from silver."crmCustInfo"

select * from silver."crmCustInfo"

--=============================================
--CHECKING silver."crmPrdInfo"
--=============================================
--check for unwanted spaces
select "prdNm"
from silver."crmPrdInfo"
where "prdNm" != trim("prdNm")

--check negative no. and values
select "prdCost"
from silver."crmPrdInfo"
where "prdCost" < 0 or "prdCost" is null

--CHECK STANDARDIZATION AND CONSISTENCY
SELECT DISTINCT "prdLine"
from silver."crmPrdInfo"
  
--check the invalid date orders
select *
from silver."crmPrdInfo"
WHERE "prdEndDt" < "prdStartDt"

select * from silver."crmPrdInfo"

--=============================================
--CHECKING silver."crmSalesDetails"
--=============================================
-- Check for invalid or placeholder values
SELECT 
    NULLIF("slsDueDt", 0) AS "slsDueDt"
FROM bronze."crmSalesDetails"
WHERE "slsDueDt" IS NULL
   OR "slsDueDt" = 0
   OR LENGTH("slsDueDt"::TEXT) <> 8  -- not in YYYYMMDD format
   OR "slsDueDt"::TEXT ~ '[^0-9]';   -- contains non-numeric characters

-- check for invalid date orders
select *
from bronze."crmSalesDetails"
WHERE "slsOrderDt" > "slsShipDt" or "slsOrderDt" > "slsDueDt"

-- check data consistency : between sales, quantity, and price
-->> sales = quantity * price
-->> values must be null, zero or negative.

SELECT DISTINCT
    "slsSales" AS "oldSlsSales",
    "slsQuantity",
    "slsPrice" AS "oldSlsPrice",
	
CASE WHEN "slsSales" IS NULL
	OR "slsSales" <= 0
	OR "slsSales" <> "slsQuantity" * ABS("slsPrice")
		THEN "slsQuantity" * ABS("slsPrice")
	ELSE "slsSales"
END AS "slsSales",

CASE WHEN "slsPrice" IS NULL 
		 OR "slsPrice" <= 0
 THEN CASE WHEN coalesce("slsQuantity",0) <> 0
	  THEN "slsSales"/"slsQuantity"
	 ELSE NULL END
  ELSE "slsPrice"
End AS "slsPrice"

FROM bronze."crmSalesDetails"
WHERE 
    "slsSales" IS NULL 
    OR "slsQuantity" IS NULL 
    OR "slsPrice" IS NULL
    OR "slsSales" <= 0 
    OR "slsQuantity" <= 0 
    OR "slsPrice" <= 0
    OR "slsSales" <> ("slsQuantity" * "slsPrice");

SELECT DISTINCT
    "slsSales",
    "slsQuantity",
    "slsPrice"
FROM silver."crmSalesDetails"
WHERE 
    "slsSales" IS NULL 
    OR "slsQuantity" IS NULL 
    OR "slsPrice" IS NULL
    OR "slsSales" <= 0 
    OR "slsQuantity" <= 0 
    OR "slsPrice" <= 0
    OR "slsSales" <> ("slsQuantity" * "slsPrice");

select * from silver."crmSalesDetails"

--=============================================
--CHECKING silver."erpCustAz12"
--=============================================
--sperating string by substring in "cId"
SELECT 
    "cId",
    CASE 
        WHEN "cId" LIKE 'NAS%' THEN SUBSTRING("cId", 4, LENGTH("cId"))
        ELSE "cId"
    END AS "cIdNormalized",
    "bDate",
    "gen"
FROM bronze."erpCustAz12"
WHERE (
    CASE 
        WHEN "cId" LIKE 'NAS%' THEN SUBSTRING("cId", 4, LENGTH("cId"))
        ELSE "cId"
    END
) NOT IN (
    SELECT DISTINCT "cstKey" 
    FROM silver."crmCustInfo"
);

--identity out of range dates
SELECT DISTINCT 
"bDate"
from silver."erpCustAz12"
where "bDate" < '1924-01-01' OR "bDate" > CURRENT_DATE

--data standardization & consistency
select distinct 
"gen",
Case when upper(trim("gen")) in ('F', 'FEMALE') then 'FEMALE'
	 when upper(trim("gen")) in ('M', 'MALE') then 'MALE'
	 else 'n/a'
end as "gen"
from bronze."erpCustAz12"

select * from silver."erpCustAz12"


--=============================================
--CHECKING silver."erpLocA101"
--=============================================
-- replacing
select
replace("cId", '-','') "cId",
"cntry"
from bronze."erpLocA101" 
where replace("cId",'-','') not in(select "cstKey" from silver."crmCustInfo")

--data standardization & consistency
SELECT DISTINCT 
	CASE
		WHEN TRIM("cntry") IN ('US','USA') THEN 'United States'
		WHEN TRIM("cntry") =  '' OR "cntry" IS NULL THEN 'n/a' 
		WHEN TRIM("cntry") = 'DE' THEN 'Germany'
			ELSE TRIM("cntry")
end as "cntry"
from bronze."erpLocA101"

--=============================================
--CHECKING silver."erpPxCatG1V2"
--=============================================
-- check for unwanted spaces
select * from bronze."erpPxCatG1V2"
	where "cat"  != trim("cat") 
	or "subCat" != trim("subCat")
	or "maintenance" != trim("maintenance")

-- data standardization and consistency
select distinct
	--"cat"
	--"subCat"
	"maintenance"
	from bronze."erpPxCatG1V2"
