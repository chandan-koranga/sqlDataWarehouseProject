
Create Database and Schemas

Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	


--Drop database if it already exists
DROP DATABASE IF EXISTS "DataWarehouse";

--Create a fresh database
CREATE DATABASE "DataWarehouse";

--Switch to the new database
\c DataWarehouse;

Create schemas inside the new database

CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
