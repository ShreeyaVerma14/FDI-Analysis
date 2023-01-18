use [FDI Data]

-------#################### Intial exploration and data cleaning  ######################

select * from FDI_Values_Yearly

--As the table has extra rows that are not needed for exploration, they have to be removed and column name to years  

--1. DELETE the NULL rows and change col names(In Table-->Design)

DELETE  
FROM FDI_Values_Yearly
WHERE Sectors IS NULL AND Sectors LIKE 'Show%'

DELETE  
FROM FDI_Values_Yearly
WHERE Sectors ='Grand Total' 

DELETE  
FROM FDI_Values_Yearly
WHERE Sectors LIKE '%Powered%'


--2. Highest value for FDI and its sector in latest year(2016)

SELECT Sectors,FDI2016
FROM FDI_Values_Yearly
WHERE FDI2016 =(SELECT MAX(FDI2016) FROM FDI_Values_Yearly)

--So the Foreign Direct Investment Value for the Services sector is the highest for the latest year in data. 
--So investing in this sector would be beneficial


--3. Lowest Value of FDI and its sector in latest year(2016)

SELECT Sectors,FDI2016
FROM FDI_Values_Yearly
WHERE FDI2016 =(SELECT MIN(FDI2016) FROM FDI_Values_Yearly)

--There are various sector that have 0 value and hence investment in same won't be of use.


--4. Total no of sectors available 

SELECT DISTINCT(Sectors) 
FROM FDI_Values_Yearly

SELECT COUNT(DISTINCT(Sectors)) As Total_Sectors 
FROM FDI_Values_Yearly


--5. Unpivot the table to get years in one column.  

CREATE VIEW Pivotted_Table AS
SELECT * 
FROM   
(SELECT Sectors,[FDI2000],[FDI2001],[FDI2002],[FDI2003],[FDI2004],[FDI2005],[FDI2006],[FDI2007],[FDI2008],
        [FDI2009],[FDI2010],[FDI2011],[FDI2012],[FDI2013],[FDI2014],[FDI2015],[FDI2016]  
FROM FDI_Values_Yearly) p  
UNPIVOT  
   (FDI_Value FOR Year_wise IN   
      ([FDI2000],[FDI2001],[FDI2002],[FDI2003],[FDI2004],[FDI2005],[FDI2006],[FDI2007],[FDI2008],
        [FDI2009],[FDI2010],[FDI2011],[FDI2012],[FDI2013],[FDI2014],[FDI2015],[FDI2016]
))AS unpvt


Select * FROM Pivotted_Table

--6. Total FDI value for each sector yearwise

SELECT Year_wise,Sectors,SUM(FDI_Value) As Total_FDI_Yearly
FROM Pivotted_Table
GROUP BY Year_wise,Sectors
ORDER BY Year_wise,Total_FDI_Yearly DESC

--7. Ranking the sectors : Get the top sector with max FDI each year

SELECT * FROM
(SELECT Sectors,Year_wise,FDI_Value,RANK() OVER (PARTITION BY Year_wise ORDER BY FDI_Value DESC) AS Rnk 
FROM Pivotted_Table) AA
WHERE Rnk=1

--8. Sectors with lowest FDI each year

SELECT * FROM
(SELECT Sectors,Year_wise,FDI_Value,RANK() OVER (PARTITION BY Year_wise ORDER BY FDI_Value ASC) AS Rnk 
FROM Pivotted_Table) AA
WHERE Rnk=3
--With changing the rank value we can see the sectors that have lowest FDI 



