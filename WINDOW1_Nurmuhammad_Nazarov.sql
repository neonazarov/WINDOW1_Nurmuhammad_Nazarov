WITH RankedSales AS (
    SELECT 
        CustomerID, 
        SalesChannel, 
        SUM(SalesAmount) AS TotalSales, 
        RANK() OVER (PARTITION BY SalesChannel ORDER BY SUM(SalesAmount) DESC) AS SalesRank,
        SaleYear
    FROM Sales
    WHERE SaleYear IN (1998, 1999, 2001)
    GROUP BY CustomerID, SalesChannel, SaleYear
)
SELECT 
    CustomerID, 
    SalesChannel, 
    FORMAT(SUM(TotalSales), 'N2') AS FormattedTotalSales
FROM RankedSales
WHERE SalesRank <= 300
GROUP BY CustomerID, SalesChannel
ORDER BY SalesChannel, SUM(TotalSales) DESC;
