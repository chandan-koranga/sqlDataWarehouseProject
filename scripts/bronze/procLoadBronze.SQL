/*
Stored Procedure: Load Bronze Layer (Source -> Bronze)
-----------------------------------------------------
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BEGIN EXECUTE END` command to load data from csv Files to bronze tables.
    - Uses 'EXCEPTION  WHEN OTHERS THEN to catch error if any.
-------------------------------------------------------------------------
Usage Example:
    call bronze.loadBronze();
*/



CREATE OR REPLACE PROCEDURE bronze.loadBronze()
LANGUAGE plpgsql
AS $$
DECLARE
    t_start TIMESTAMP;
    t_end   TIMESTAMP;
BEGIN
    BEGIN
        RAISE NOTICE '==========================';
        RAISE NOTICE 'Loading bronze tables';
        RAISE NOTICE 'Start Time: %', clock_timestamp();
        RAISE NOTICE '==========================';

        -- CRM tables
        RAISE NOTICE '-------------------------';
        RAISE NOTICE 'CRM tables';
        RAISE NOTICE '-------------------------';

        -- crmCustInfo
        t_start := clock_timestamp();
        RAISE NOTICE '>> Truncating table: bronze.crmCustInfo (Start: %)', t_start;
        TRUNCATE TABLE bronze."crmCustInfo";
        t_end := clock_timestamp();
        RAISE NOTICE '>> Truncate finished: bronze.crmCustInfo (End: %, Duration: %)', t_end, t_end - t_start;

        t_start := clock_timestamp();
        RAISE NOTICE '>> Inserting data into: bronze.crmCustInfo (Start: %)', t_start;
        EXECUTE 'COPY bronze."crmCustInfo"
                 FROM ''E:\\sql-data-warehouse-project\\datasets\\sourceCrm\\custInfo.csv''
                 DELIMITER '','' CSV HEADER';
        t_end := clock_timestamp();
        RAISE NOTICE '>> Insert finished: bronze.crmCustInfo (End: %, Duration: %)', t_end, t_end - t_start;

        -- crmPrdInfo
        t_start := clock_timestamp();
        RAISE NOTICE '>> Truncating table: bronze.crmPrdInfo (Start: %)', t_start;
        TRUNCATE TABLE bronze."crmPrdInfo";
        t_end := clock_timestamp();
        RAISE NOTICE '>> Truncate finished: bronze.crmPrdInfo (End: %, Duration: %)', t_end, t_end - t_start;

        t_start := clock_timestamp();
        RAISE NOTICE '>> Inserting data into: bronze.crmPrdInfo (Start: %)', t_start;
        EXECUTE 'COPY bronze."crmPrdInfo"
                 FROM ''E:\\sql-data-warehouse-project\\datasets\\sourceCrm\\prdInfo.csv''
                 DELIMITER '','' CSV HEADER';
        t_end := clock_timestamp();
        RAISE NOTICE '>> Insert finished: bronze.crmPrdInfo (End: %, Duration: %)', t_end, t_end - t_start;

        -- crmSalesDetails
        t_start := clock_timestamp();
        RAISE NOTICE '>> Truncating table: bronze.crmSalesDetails (Start: %)', t_start;
        TRUNCATE TABLE bronze."crmSalesDetails";
        t_end := clock_timestamp();
        RAISE NOTICE '>> Truncate finished: bronze.crmSalesDetails (End: %, Duration: %)', t_end, t_end - t_start;

        t_start := clock_timestamp();
        RAISE NOTICE '>> Inserting data into: bronze.crmSalesDetails (Start: %)', t_start;
        EXECUTE 'COPY bronze."crmSalesDetails"
                 FROM ''E:\\sql-data-warehouse-project\\datasets\\sourceCrm\\salesDetails.csv''
                 DELIMITER '','' CSV HEADER';
        t_end := clock_timestamp();
        RAISE NOTICE '>> Insert finished: bronze.crmSalesDetails (End: %, Duration: %)', t_end, t_end - t_start;

        -- ERP tables
        RAISE NOTICE '-------------------------';
        RAISE NOTICE 'ERP tables';
        RAISE NOTICE '-------------------------';

        -- erpLocA101
        t_start := clock_timestamp();
        RAISE NOTICE '>> Truncating table: bronze.erpLocA101 (Start: %)', t_start;
        TRUNCATE TABLE bronze."erpLocA101";
        t_end := clock_timestamp();
        RAISE NOTICE '>> Truncate finished: bronze.erpLocA101 (End: %, Duration: %)', t_end, t_end - t_start;

        t_start := clock_timestamp();
        RAISE NOTICE '>> Inserting data into: bronze.erpLocA101 (Start: %)', t_start;
        EXECUTE 'COPY bronze."erpLocA101"
                 FROM ''E:\\sql-data-warehouse-project\\datasets\\sourceErp\\locA101.csv''
                 DELIMITER '','' CSV HEADER';
        t_end := clock_timestamp();
        RAISE NOTICE '>> Insert finished: bronze.erpLocA101 (End: %, Duration: %)', t_end, t_end - t_start;

        -- erpCustAz12
        t_start := clock_timestamp();
        RAISE NOTICE '>> Truncating table: bronze.erpCustAz12 (Start: %)', t_start;
        TRUNCATE TABLE bronze."erpCustAz12";
        t_end := clock_timestamp();
        RAISE NOTICE '>> Truncate finished: bronze.erpCustAz12 (End: %, Duration: %)', t_end, t_end - t_start;

        t_start := clock_timestamp();
        RAISE NOTICE '>> Inserting data into: bronze.erpCustAz12 (Start: %)', t_start;
        EXECUTE 'COPY bronze."erpCustAz12"
                 FROM ''E:\\sql-data-warehouse-project\\datasets\\sourceErp\\custAz12.csv''
                 DELIMITER '','' CSV HEADER';
        t_end := clock_timestamp();
        RAISE NOTICE '>> Insert finished: bronze.erpCustAz12 (End: %, Duration: %)', t_end, t_end - t_start;

        -- erpPxCatG1V2
        t_start := clock_timestamp();
        RAISE NOTICE '>> Truncating table: bronze.erpPxCatG1V2 (Start: %)', t_start;
        TRUNCATE TABLE bronze."erpPxCatG1V2";
        t_end := clock_timestamp();
        RAISE NOTICE '>> Truncate finished: bronze.erpPxCatG1V2 (End: %, Duration: %)', t_end, t_end - t_start;

        t_start := clock_timestamp();
        RAISE NOTICE '>> Inserting data into: bronze.erpPxCatG1V2 (Start: %)', t_start;
        EXECUTE 'COPY bronze."erpPxCatG1V2"
                 FROM ''E:\\sql-data-warehouse-project\\datasets\\sourceErp\\pxCatG1V2.csv''
                 DELIMITER '','' CSV HEADER';
        t_end := clock_timestamp();
        RAISE NOTICE '>> Insert finished: bronze.erpPxCatG1V2 (End: %, Duration: %)', t_end, t_end - t_start;

        RAISE NOTICE '==========================';
        RAISE NOTICE 'Bronze load finished!';
        RAISE NOTICE 'End Time: %', clock_timestamp();
        RAISE NOTICE '==========================';

    EXCEPTION
        WHEN OTHERS THEN
            RAISE WARNING 'Error in loadBronze procedure: %', SQLERRM;
    END;
END;
$$;
