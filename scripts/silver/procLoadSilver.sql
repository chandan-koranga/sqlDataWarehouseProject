/*
Stored Procedure: Load Bronze Layer (Bronze Layer -> Silver Layer)
-----------------------------------------------------
Script Purpose:
    This stored procedure loads data into the 'silver' schema from bronze layer. 
    It performs the following actions:
    - Truncates the silver tables before loading data.
    - Uses the `BEGIN END` command to load data from bronze tables to silver tables.
    - Uses 'EXCEPTION  WHEN OTHERS THEN to catch error if any.
-------------------------------------------------------------------------
Usage Example:
    call silver.loadSilver();
*/

CREATE OR REPLACE PROCEDURE silver.loadSilver()
LANGUAGE plpgsql
AS $$
DECLARE 
		t_start TIMESTAMP;
		t_end TIMESTAMP;
BEGIN
	RAISE NOTICE '==========================';
        RAISE NOTICE 'Loading Silver layer';
        RAISE NOTICE 'Start Time: %', clock_timestamp();
        RAISE NOTICE '==========================';

        RAISE NOTICE '-------------------------';
        RAISE NOTICE 'Loading CRM tables';
        RAISE NOTICE '-------------------------';

	-- Loading silver.crmCustInfo
	t_start := clock_timestamp();
	RAISE NOTICE '>>Truncating Table: silver."crmCustInfo"(Start: %)', t_start;
	TRUNCATE TABLE silver."crmCustInfo";
	t_end := clock_timestamp();
	RAISE NOTICE '>> Truncate finished: silver.crmCustInfo (End: %, Duration: %)', t_end, t_end - t_start;

	t_start := clock_timestamp();
	RAISE NOTICE'>>Inserting Data Into: silver."crmCustInfo"(Start: %)', t_start;
	INSERT INTO silver."crmCustInfo"(
		"cstId",
		"cstKey",
		"cstFirstName",
		"cstLastName",
		"cstMaritalStatus",
		"cstGndr",
		"cstCreateDate")
	SELECT 
	"cstId",
	"cstKey",
	trim("cstFirstName") AS "cstFirstName",
	Trim("cstLastName") AS "cstLastName", --remove unwant spaces
		CASE 
			WHEN UPPER(TRIM("cstMaritalStatus")) = 'S' THEN 'Single'
			WHEN UPPER(TRIM("cstMaritalStatus")) = 'M' THEN 'Married'
			ELSE 'n/a'
		END AS "cstMaritalStatus",--data normalization & standarization.
	
		CASE 
			WHEN UPPER(TRIM("cstGndr")) = 'F' THEN 'Female'
			WHEN UPPER(TRIM("cstGndr")) = 'M' THEN 'Male'
			ELSE 'n/a'
		END AS "cstGndr",--data normalization & standarization.
		"cstCreateDate"
	FROM(
		select *, 
		ROW_NUMBER () OVER (
					partition by "cstId" order by "cstCreateDate" DESC) as "flagLast" 
	
		from bronze."crmCustInfo"
		)t WHERE "flagLast"= 1; -- select the most recent record per customer.
	t_end := clock_timestamp();
	RAISE NOTICE '>> Inserting finished: silver.crmCustInfo (End: %, Duration: %)', t_end, t_end - t_start;

-- Loading silver.crmPrdInfo
	t_start := clock_timestamp();
	RAISE NOTICE '>>Truncating Table: silver."crmPrdInfo"(Start: %)', t_start;
	TRUNCATE TABLE silver."crmPrdInfo";
	t_end := clock_timestamp();
	RAISE NOTICE '>> Truncate finished: bronze.crmPrdInfo (End: %, Duration: %)', t_end, t_end - t_start;

	t_start := clock_timestamp();
	RAISE NOTICE '>>Inserting Data Into: silver."crmPrdInfo"(Start: %)', t_start;
	INSERT INTO silver."crmPrdInfo"(
		"prdId",
		"cstId",
		"prdKey",
		"prdNm",
		"prdCost",
		"prdLine",
		"prdStartDt",
		"prdEndDt"
	)
	select 
	"prdId",
	REPLACE(SUBSTRING("prdKey", 1, 5), '-','_')  AS "cstId",
	SUBSTRING("prdKey" FROM 7) AS "prdKeyExt",
	"prdNm",
	COALESCE("prdCost", 0) AS "prdCost",
	CASE UPPER(TRIM("prdLine"))
		WHEN 'M' THEN 'Mountain'
		WHEN 'R' THEN 'Road'
		WHEN'S' Then 'other Sales'
		WHEN 'T' THEN 'Touring'
		Else 'n/a'
	End AS "prdLine",
	CAST("prdStartDt" AS DATE) AS "prdStartDt",
	CAST(LEAD("prdStartDt") OVER (
		PARTITION BY "prdKey" 
		ORDER by "prdStartDt")- interval '1 day' AS date)  AS "prdEndDt"
	from bronze."crmPrdInfo";
	t_end := clock_timestamp();
	RAISE NOTICE '>> Inserting finished: silver.crmPrdInfo (End: %, Duration: %)', t_end, t_end - t_start;

-- Loading silver.crmSalesDetails
	t_start := clock_timestamp();
	RAISE NOTICE '>>Truncating Table: silver."crmSalesDetails"(Start: %)', t_start;
	TRUNCATE TABLE silver."crmSalesDetails";
	t_end := clock_timestamp();
	RAISE NOTICE '>> Truncate finished: silver.crmSalesDetails (End: %, Duration: %)', t_end, t_end - t_start;

	t_start := clock_timestamp();
	RAISE NOTICE '>>Inserting Data Into: silver."crmSalesDetails"(Start: %)', t_start;
	INSERT INTO silver."crmSalesDetails" (
			"slsOrdNum",
			"slsPrdKey",
			"slsCustId",
			"slsOrderDt",
			"slsShipDt",
			"slsDueDt",
			"slsSales",
			"slsQuantity",
			"slsPrice"
		)
	SELECT
		"slsOrdNum",
		"slsPrdKey",
		"slsCustId",
		CASE
			WHEN "slsOrderDt" = 0
			OR LENGTH("slsOrderDt"::TEXT) <> 8 THEN NULL
			ELSE TO_DATE("slsOrderDt"::TEXT, 'YYYYMMDD')
		END AS "slsOrderDt",
		CASE
			WHEN "slsShipDt" = 0
			OR LENGTH("slsShipDt"::TEXT) <> 8 THEN NULL
			ELSE TO_DATE("slsShipDt"::TEXT, 'YYYYMMDD')
		END AS "slsShipDt",
		CASE
			WHEN "slsDueDt" = 0
			OR LENGTH("slsDueDt"::TEXT) <> 8 THEN NULL
			ELSE TO_DATE("slsDueDt"::TEXT, 'YYYYMMDD')
		END AS "slsDueDt",
		CASE
			WHEN "slsSales" IS NULL
			OR "slsSales" <= 0
			OR "slsSales" <> "slsQuantity" * ABS("slsPrice") THEN "slsQuantity" * ABS("slsPrice")
			ELSE "slsSales"
		END AS "slsSales",
		"slsQuantity",
		CASE
			WHEN "slsPrice" IS NULL
			OR "slsPrice" <= 0 THEN CASE
				WHEN COALESCE("slsQuantity", 0) <> 0 THEN "slsSales" / "slsQuantity"
				ELSE NULL
			END
			ELSE "slsPrice"
		END AS "slsPrice"
	FROM bronze."crmSalesDetails";
	
	-- WHERE
	-- 	NOT EXISTS (
	-- 		SELECT
	-- 			"cstId"
	-- 		FROM silver."crmCustInfo"
	-- 	)
	t_end := clock_timestamp();
	RAISE NOTICE '>> Inserting finished: silver.crmSalesDetails (End: %, Duration: %)', t_end, t_end - t_start;

-- Loading silver.erpCustAz12	
	t_start := clock_timestamp();
	RAISE NOTICE '>>Truncating Table: silver."erpCustAz12"(Start: %)', t_start;
	TRUNCATE TABLE silver."erpCustAz12";
	t_end := clock_timestamp();
	RAISE NOTICE '>> Truncate finished: silver.erpCustAz12 (End: %, Duration: %)', t_end, t_end - t_start;

	t_start := clock_timestamp();
	RAISE NOTICE '>>Inserting Data Into: silver."erpCustAz12"(Start: %)', t_start;
	insert into silver."erpCustAz12"(
			"cId",
			"bDate",
			"gen"
	)
	SELECT
		CASE
			WHEN "cId" LIKE 'NAS%' THEN SUBSTRING("cId", 4, LENGTH("cId"))
			ELSE "cId"
		END AS "cIdNormalized",
		CASE
			WHEN "bDate" > CURRENT_DATE THEN NULL
			ELSE "bDate"
		END AS "bDate",
		CASE
			WHEN UPPER(TRIM("gen")) IN ('F', 'FEMALE') THEN 'FEMALE'
			WHEN UPPER(TRIM("gen")) IN ('M', 'MALE') THEN 'MALE'
			ELSE 'n/a'
		END AS "gen"
	FROM
		bronze."erpCustAz12";
	t_end := clock_timestamp();
	RAISE NOTICE '>> Inserting finished: silver.erpCustAz12 (End: %, Duration: %)', t_end, t_end - t_start;

-- Loading silver.erpLocA101
	t_start := clock_timestamp();
	RAISE NOTICE '>>Truncating Table: silver."erpLocA101"(Start: %)', t_start;
	TRUNCATE TABLE silver."erpLocA101";
	t_end := clock_timestamp();
	RAISE NOTICE '>> Truncate finished: silver.erpLocA101 (End: %, Duration: %)', t_end, t_end - t_start;

	t_start := clock_timestamp();
	RAISE NOTICE '>>Inserting Data Into: silver."erpLocA101"(Start: %)', t_start;
	
	INSERT INTO silver."erpLocA101"(
		"cId",
		"cntry"
	)
	SELECT
	replace("cId",'-','') "cId",
		CASE
			WHEN TRIM("cntry") IN ('US','USA') THEN 'United States'
			WHEN TRIM("cntry") =  '' OR "cntry" IS NULL THEN 'n/a' 
			WHEN TRIM("cntry") = 'DE' THEN 'Germany'
			ELSE TRIM("cntry")
	end as "cntry"
	from bronze."erpLocA101";
	t_end := clock_timestamp();
	RAISE NOTICE '>> Inserting finished: silver.erpLocA101 (End: %, Duration: %)', t_end, t_end - t_start;
	
-- Loading silver.erpPxCatG1V2
	t_start := clock_timestamp();
	RAISE NOTICE '>>Truncating Table: silver."erpPxCatG1V2"(Start: %)', t_start;
	TRUNCATE TABLE silver."erpPxCatG1V2";
	t_end := clock_timestamp();
	RAISE NOTICE '>> Truncate finished: silver.erpPxCatG1V2 (End: %, Duration: %)', t_end, t_end - t_start;

	t_start := clock_timestamp();
	RAISE NOTICE '>>Inserting Data Into: silver."erpPxCatG1V2"(Start: %)', t_start;
	
	insert into silver."erpPxCatG1V2"(
		"id",
		"cat",
		"subCat",
		"maintenance"
	)
	SELECT 
		"id",
		"cat",
		"subCat",
		"maintenance"
	FROM bronze."erpPxCatG1V2";
	t_end := clock_timestamp();
	RAISE NOTICE '>> Inserting finished: silver.erpPxCatG1V2 (End: %, Duration: %)', t_end, t_end - t_start;

	RAISE NOTICE '==========================';
    RAISE NOTICE 'Silver Load Completed Successfully at %', clock_timestamp();
    RAISE NOTICE '==========================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '==========================';
        RAISE NOTICE '!! ERROR in silver.loadSilver !!';
        RAISE NOTICE 'Error message: %', SQLERRM;
        RAISE NOTICE 'Error state: %', SQLSTATE;
        RAISE NOTICE '==========================';
END
$$;

CALL silver.loadSilver();
