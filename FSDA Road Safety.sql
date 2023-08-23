                                  🎯Analyzing Road Safety in the UK
                                  
                                  
Business problem:

The UK Department of Transport provides open datasets on road safety and casualties, and one can
use these datasets to analyze how safe the roads in the UK are. This project will help you answer a
few questions using their 2015 dataset.

The dataset has 3 tables i.e Accident, vehicle, Vehicle_type

CREATE DATABASE iNeuron_Master_SQL_Project;

USE iNeuron_Master_SQL_Project;

CREATE TABLE Acidents_2015(
Accident_Index	varchar(100),
Location_Easting_OSGR INT(50),
Location_Northing_OSGR	INT(50),
Longitude	DECIMAL(10,10),
Latitude	DECIMAL(10,10),
Police_Force	INT(5),
Accident_Severity	INT(5),
Number_of_Vehicles	INT(5),
Number_of_Casualties	INT(5),
`Date`	date,
Day_of_Week	INT(5),
`Time`	TIME(6),
Local_Authority_District INT(50),
Local_Authority_Highway	VARCHAR(50),
1st_Road_Class	INT(50),
1st_Road_Number	INT(50),
Road_Type	INT(50),
Speed_limit	INT(50),
Junction_Detail	INT(50),
Junction_Control	INT(50),
2nd_Road_Class	INT(50),
2nd_Road_Number	INT(50),
Pedestrian_Crossing_Human_Control	INT(50),
Pedestrian_Crossing_Physical_Facilities	INT(50),
Light_Conditions	INT(50),
Weather_Conditions	INT(50),
Road_Surface_Conditions	INT(50),
Special_Conditions_at_Site	INT(50),
Carriageway_Hazards	INT(50),
Urban_or_Rural_Area	INT(50),
Did_Police_Officer_Attend_Scene_of_Accident	INT(50),
LSOA_of_Accident_Location VARCHAR(100)
);

SELECT * FROM Acidents_2015;

LOAD DATA LOCAL INFILE 'C:\\Users\\Accidents_2015.csv'
INTO TABLE Acidents_2015
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

Create table Vehicles_2015(
Accident_Index	VARCHAR(100),
Vehicle_Reference	INT(100),
Vehicle_Type	INT(100),
Towing_and_Articulation	INT(100),
Vehicle_Manoeuvre	INT(100),
Vehicle_Location_Restricted_Lane INT(100),	
Junction_Location	INT(100),
Skidding_and_Overturning	INT(100),
Hit_Object_in_Carriageway	INT(100),
Vehicle_Leaving_Carriageway	 INT(100),
Hit_Object_off_Carriageway	INT(100),
1st_Point_of_Impact	INT(100),
Was_Vehicle_Left_Hand_Drive	INT(100),
Journey_Purpose_of_Driver	INT(100),
Sex_of_Driver	INT(100),
Age_of_Driver	INT(100),
Age_Band_of_Driver	INT(100),
Engine_Capacity_CC	INT(100),
Propulsion_Code	INT(100),
Age_of_Vehicle	INT(100),
Driver_IMD_Decile	INT(100),
Driver_Home_Area_Type	INT(100),
Vehicle_IMD_Decile INT(100)
);

SELECT * FROM Vehicles_2015;

LOAD DATA LOCAL INFILE 'C:\\Users\\Vehicles_2015.csv'
INTO TABLE vehicles_2015
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

create table vehicle_types(
`CODE` INT,
LABEL VARCHAR(100)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\vehicle_types.csv'
INTO TABLE vehicle_types
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

Approach/Project Idea
Use aggregate functions in SQL and Python to answer the following sample questions:
1. Evaluate the median severity value of accidents caused by various Motorcycles.
2. Evaluate Accident Severity and Total Accidents per Vehicle Type
3. Calculate the Average Severity by vehicle type.
4. Calculate the Average Severity and Total Accidents by Motorcycle.

                           ANSWER
       
SELECT * FROM accidents_2015;
SELECT * FROM Vehicles_2015;
SELECT * FROM vehicle_types;

-- ANALYZE ROAD SAFETY IN THE UK
-- 1. Evaluate the median severity value of accidents caused by various Motorcycles?
SELECT label, 
       AVG(Accident_Severity) AS Median_Severity
FROM (
  SELECT VT.label, 
         A.Accident_Severity,
         @row_num := IF(@prev_label = VT.label, @row_num + 1, 1) AS row_num,
         @prev_label := VT.label
  FROM accidents_2015 A 
  JOIN Vehicles_2015 V ON A.Accident_Index = V.Accident_Index
  JOIN vehicle_types VT ON VT.Code = V.Vehicle_Type
  JOIN (SELECT @row_num := 0, @prev_label := '') AS vars
  WHERE VT.label LIKE '%Motorcycle%'
  ORDER BY VT.label, A.Accident_Severity
) AS Subquery
WHERE row_num = CEIL(@row_num / 2)
GROUP BY label;


-- 2. Evaluate Accident Severity and Total Accidents per Vehicle Type?
SELECT VT.label as Veichle_Type, A.Accident_Severity AS Accident_Severity, COUNT(1) AS Total_Accidents
FROM accidents_2015 A 
JOIN Vehicles_2015 V ON A.Accident_Index=V.Accident_Index
JOIN vehicle_types VT ON VT.Code=v.Vehicle_Type
GROUP BY VT.label,A.Accident_Severity
Order by Total_Accidents desc;

-- 3. Calculate the Average Severity by vehicle type.
SELECT VT.label as Vehicle_Type, AVG(A.Accident_Severity) AS Average_Severity FROM accidents_2015 A 
JOIN Vehicles_2015 V ON A.Accident_Index=V.Accident_Index
JOIN vehicle_types VT ON VT.Code=v.Vehicle_Type
GROUP BY VT.label;

-- 4. Calculate the Average Severity and Total Accidents by Motorcycle.
SELECT VT.label, AVG(A.Accident_Severity) AS Median_Severity, COUNT(1) AS Total_Accidents
FROM accidents_2015 A 
JOIN Vehicles_2015 V ON A.Accident_Index=V.Accident_Index
JOIN vehicle_types VT ON VT.Code=v.Vehicle_Type
WHERE VT.label LIKE '%Motorcycle%'
GROUP BY VT.label;



