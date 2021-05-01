--pig -x local valentinahw3.pig
Stores = LOAD './orders.csv' using PigStorage(',') AS
(id:chararray, cdID:int, dayPurchase:int, hourPurchase:int, pricePaid:int, salesPersonID:int, storeID:int);

Storelist = FOREACH Stores GENERATE cdID, pricePaid, storeID;

Prices = FILTER Storelist by pricePaid >= 10;

StoreFilter = FILTER Prices by storeID > 0;

StoreSalesGroup = GROUP StoreFilter by storeID; 

StoresCount = FOREACH StoreSalesGroup GENERATE group, COUNT(StoreFilter);

StoreDESC = ORDER StoresCount BY $1 DESC;

TopThree = LIMIT StoreDESC 3;

STORE TopThree INTO 'TopThreeStores';
