/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. 
    These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/
-- =============================================================================
-- Check Dimension: gold.dimCustomer
-- =============================================================================
-- Check for Uniqueness of Customer Key in gold."dimCustomer"
-- Expectation: No results 
SELECT 
    "customerKey",
    COUNT(*) AS duplicate_count
FROM gold."dimCustomer"
GROUP BY "customerKey"
HAVING COUNT(*) > 1;

-- =============================================================================
-- Check Dimension: gold.dimProducts
-- =============================================================================
-- Check for Uniqueness of Product Key in gold."dimProducts"
-- Expectation: No results 
SELECT 
    "productKey",
    COUNT(*) AS duplicate_count
FROM gold."dimProducts"
GROUP BY "productKey"
HAVING COUNT(*) > 1;

-- =============================================================================
-- Check Dimension: gold.factSales
-- =============================================================================
-- foreign key integrity B/W (Fact & Dimensions)
SELECT * 
FROM gold."factSales" f
LEFT JOIN gold."dimCustomer" c
ON c."customerKey" = f."customerKey"
LEFT JOIN gold."dimProducts" p
ON p."productKey" = f."productKey"
WHERE p."productKey" IS NULL OR c."customerKey" IS NULL
