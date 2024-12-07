create table ei_copy like
economic_indicators_dataset_2010_2023;

insert ei_copy
select * from economic_indicators_dataset_2010_2023;

select *  from ei_copy;

-- identify trend over time

SELECT Date, AVG(`Inflation Rate (%)`) AS Avg_Inflation, AVG(`GDP Growth Rate (%)`) AS Avg_GDP_Growth
FROM ei_copy
GROUP BY Date
ORDER BY Date;

-- correlation between inflation and interest

SELECT 
    Country,
    SUM((`Inflation Rate (%)` - AvgInflation) * (`Interest Rate (%)` - AvgInterest)) / 
    (SQRT(SUM(POW(`Inflation Rate (%)` - AvgInflation, 2))) * 
     SQRT(SUM(POW(`Interest Rate (%)` - AvgInterest, 2)))) AS Correlation
FROM (
    SELECT 
        Country,
        `Inflation Rate (%)`,
        `Interest Rate (%)`,
        AVG(`Inflation Rate (%)`) OVER (PARTITION BY Country) AS AvgInflation,
        AVG(`Interest Rate (%)`) OVER (PARTITION BY Country) AS AvgInterest
    FROM ei_copy
) AS SubQuery
GROUP BY Country;

-- identify countries with most stable economies
-- identify period of economic crises  

 SELECT Country, 
       STDDEV(`Inflation Rate (%)`) AS Inflation_Volatility,
       STDDEV(`GDP Growth Rate (%)`) AS GDP_Volatility
FROM ei_copy
GROUP BY Country
ORDER BY Inflation_Volatility ASC, GDP_Volatility ASC;

SELECT Date, Country, `GDP Growth Rate (%)`, `Inflation Rate (%)`
FROM ei_copy
WHERE `GDP Growth Rate (%)` < 0 OR `Inflation Rate (%)` > 10
ORDER BY Date;

-- inflation and unemployment relation 

SELECT Country, `Inflation Rate (%)`, `Unemployment Rate (%)`
FROM ei_copy
WHERE `Inflation Rate (%)` IS NOT NULL AND `Unemployment Rate (%)` IS NOT NULL
ORDER BY Country;

-- Top Performers in Stock Market

SELECT Country, AVG(`Stock Index Value`) AS Avg_Stock_Value
FROM ei_copy
GROUP BY Country
ORDER BY Avg_Stock_Value DESC;
 