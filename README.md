# Insights from Decades of Earthquake Data: SQL Analysis of Events from 1965 to 2016  

![image](https://github.com/Banuvathyrr/Data-cleaning-of-Earthquake-dataset-using-SQL/assets/145739539/aa558f61-6152-44d3-b43d-b006e3052a33)

### Data Discovery: 
Initial exploration of the dataset performed to understand its structure and contents.   

### Data Cleaning:    
1) Standardised date and time formats.  
2) Handled inconsistencies and errors in date and time columns.  
3) Handled blank rows and converting text columns to double. 
4) Extracted year, month, week, and day name from the date column.  
5) Handled outliers and dropping unnecessary columns.    
**SQL functions used**:  LEFT(), str_to_date(), substr(), CAST(),ALTER TABLE,EXTRACT(), WEEK(), dayname(),ROW_NUMBER(), WITH ... AS, Case structure.

### Data Analysis:
1) Analysed the distribution of earthquakes over different years, months, and weeks.
2) Identified the year with the highest number of earthquakes.  
3) Calculated the average number of earthquakes per month.  
4) Identified regions with the highest number of earthquakes.  
5) Analyzing earthquake magnitudes across different types.  
6) Investigated earthquake reporting sources and statuses.  
7) Analyzed variations in earthquake frequency over time using moving averages.  
8) Ranked earthquakes based on their magnitudes within each year.  
9) Identified regions with the highest number of earthquakes.  
10) Calculated the average magnitude of earthquakes each year.  
11) Identified the highest magnitude earthquake recorded in the dataset.    
**SQL functions used**:Aggregate functions:COUNT(),AVG(),MAX(), Window functions: RANK(), DENSE_RANK(),OVER(), Common table expression (CTE)

### Insights:
1) Maximum earthquakes occurred in 2011, with March and July being the most active months.  
2) University of Washington reported the highest number of earthquakes.  
3) The majority of earthquakes were reviewed by experts, indicating a robust reporting and analysis system.  
4) The analysis revealed fluctuations in earthquake frequency over time, with a peak in 2011.
5) The highest magnitude earthquakes were recorded in 2004 and 2011.
