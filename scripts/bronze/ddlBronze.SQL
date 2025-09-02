DROP TABLE IF EXISTS bronze."crmCustInfo";
CREATE TABLE bronze."crmCustInfo" (
    "cstId"             INT,
    "cstKey"            VARCHAR(50),
    "cstFirstname"      VARCHAR(50),
    "cstLastname"       VARCHAR(50),
    "cstMaritalStatus"  VARCHAR(50),
    "cstGndr"           VARCHAR(50),
    "cstCreateDate"     DATE
);

DROP TABLE IF EXISTS bronze."crmPrdInfo";
CREATE TABLE bronze."crmPrdInfo" (
    "prdId"       INT,
    "prdKey"      VARCHAR(50),
    "prdNm"       VARCHAR(50),
    "prdCost"     INT,
    "prdLine"     VARCHAR(50),
    "prdStartDt"  TIMESTAMP,
    "prdEndDt"    TIMESTAMP
);

DROP TABLE IF EXISTS bronze."crmSalesDetails";
CREATE TABLE bronze."crmSalesDetails" (
    "slsOrdNum"   VARCHAR(50),
    "slsPrdKey"   VARCHAR(50),
    "slsCustId"   INT,
    "slsOrderDt"  INT,
    "slsShipDt"   INT,
    "slsDueDt"    INT,
    "slsSales"    INT,
    "slsQuantity" INT,
    "slsPrice"    INT
);

DROP TABLE IF EXISTS bronze."erpLocA101";
CREATE TABLE bronze."erpLocA101" (
    "cId"    VARCHAR(50),
    "cntry"  VARCHAR(50)
);

DROP TABLE IF EXISTS bronze."erpCustAz12";
CREATE TABLE bronze."erpCustAz12" (
   "cId"    VARCHAR(50),
    "bDate"  DATE,
    "gen"    VARCHAR(50)
);

DROP TABLE IF EXISTS bronze."erpPxCatG1v2";
CREATE TABLE bronze."erpPxCatG1v2" (
    "id"         VARCHAR(50),
    "cat"         VARCHAR(50),
    "subCat"      VARCHAR(50),
    "maintenance" VARCHAR(50)
);
