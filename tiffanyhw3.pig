Orders = LOAD './orders.csv' using PigStorage(',') AS
(id:chararray, cdID:int, dayPurchase:int, hourPurchase:int, pricePaid:int, salesPersonID:int, storeID:chararray);

SalesPersonList = FOREACH Orders GENERATE cdID, hourPurchase, salesPersonID;

EveningHours = FILTER SalesPersonList by hourPurchase > 18;

CDs = FILTER EveningHours by cdID > 1;

SalesIDGroup = GROUP CDs by salesPersonID;

CDCount = FOREACH SalesIDGroup GENERATE group, COUNT(CDs);

SalesPersonDESC = ORDER CDCount BY $1 DESC;

TopTen = LIMIT SalesPersonDESC 10;

STORE TopTen INTO 'TopTenSalesPeople';
