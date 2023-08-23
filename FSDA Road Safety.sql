
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



