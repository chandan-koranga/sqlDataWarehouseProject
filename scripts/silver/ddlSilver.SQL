DROP TABLE IF EXISTS silver.crmCustInfo;
CREATE TABLE silver.crmCustInfo (
    cstId             INT,
    cstKey            VARCHAR(50),
    cstFirstname      VARCHAR(50),
    cstLastname       VARCHAR(50),
    cstMaritalStatus  VARCHAR(50),
    cstGndr           VARCHAR(50),
    cstCreateDate     DATE,
    dwhCreateDate     TIMESTAMP DEFAULT now()
);

DROP TABLE IF EXISTS silver.crmPrdInfo;
CREATE TABLE silver.crmPrdInfo (
    prdId        INT,
    prdKey       VARCHAR(50),
    prdNm        VARCHAR(50),
    prdCost      INT,
    prdLine      VARCHAR(50),
    prdStartDt   TIMESTAMP,
    prdEndDt     TIMESTAMP,
    dwhCreateDate TIMESTAMP DEFAULT now()
);

DROP TABLE IF EXISTS silver.crmSalesDetails;
CREATE TABLE silver.crmSalesDetails (
    slsOrdNum    VARCHAR(50),
    slsPrdKey    VARCHAR(50),
    slsCustId    INT,
    slsOrderDt   DATE,
    slsShipDt    DATE,
    slsDueDt     DATE,
    slsSales     INT,
    slsQuantity  INT,
    slsPrice     INT,
    dwhCreateDate TIMESTAMP DEFAULT now()
);

DROP TABLE IF EXISTS silver.erpLocA101;
CREATE TABLE silver.erpLocA101 (
    cid          VARCHAR(50),
    cntry        VARCHAR(50),
    dwhCreateDate TIMESTAMP DEFAULT now()
);

DROP TABLE IF EXISTS silver.erpCustAz12;
CREATE TABLE silver.erpCustAz12 (
    cid          VARCHAR(50),
    bdate        DATE,
    gen          VARCHAR(50),
    dwhCreateDate TIMESTAMP DEFAULT now()
);

DROP TABLE IF EXISTS silver.erpPxCatG1v2;
CREATE TABLE silver.erpPxCatG1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(50),
    subcat       VARCHAR(50),
    maintenance  VARCHAR(50),
    dwhCreateDate TIMESTAMP DEFAULT now()
);
