USE workforce_hr_analytics;

SELECT * FROM employees_cleaned;

SELECT * FROM departments_cleaned;

SELECT * FROM attendance_cleaned;

SELECT * FROM performance_cleaned;

SHOW TABLES;

# Total number of employees
SELECT COUNT(*) AS Total_Employees
FROM employees_cleaned;

#Active and Resigned Employees
SELECT Employment_Status,
COUNT(*) AS Employee_Count
FROM employees_cleaned
GROUP BY Employment_Status;

# – Employee Count by Department
SELECT Department,
COUNT(*) AS Total_Employees
FROM employees_cleaned
GROUP BY Department
ORDER BY Total_Employees DESC;

# Employee Count by Location
SELECT
Location,
COUNT(*) AS Employee_Count
FROM employees_cleaned
GROUP BY Location
ORDER BY Employee_Count DESC;

# Average Salary by Department
SELECT
Department,
ROUND(AVG(Monthly_Salary), 2) AS Average_Salary
FROM employees_cleaned
GROUP BY Department
ORDER BY Average_Salary DESC;

# Total Resigned Employees by Reason
SELECT
Resignation_Reason,
COUNT(*) AS Total_Resignations
FROM employees_cleaned
WHERE Employment_Status = 'Resigned'
GROUP BY Resignation_Reason
ORDER BY Total_Resignations DESC;

# Resignations by Month
SELECT
MONTHNAME(Resignation_Date) AS Resignation_Month,
COUNT(*) AS Total_Resignations
FROM employees_cleaned
WHERE Resignation_Date IS NOT NULL
GROUP BY MONTH(Resignation_Date), MONTHNAME(Resignation_Date)
ORDER BY MONTH(Resignation_Date);

# Attendance Status Distribution
SELECT
Status,
COUNT(*) AS Total_Records
FROM attendance_cleaned
GROUP BY Status
ORDER BY Total_Records DESC;

#Query 9 – Overall Attendance Rate
SELECT
ROUND(SUM(Is_Attended) * 100.0 / COUNT(*), 2) AS Attendance_Rate
FROM attendance_cleaned;

#Query 10 – Monthly Attendance Trend
SELECT
Attendance_Month,
ROUND(AVG(Is_Attended) * 100, 2) AS Attendance_Rate
FROM attendance_cleaned
GROUP BY Attendance_Month
ORDER BY MIN(Attendance_Date);

# Average Performance Rating by Department
SELECT
e.Department,
ROUND(AVG(p.Performance_Rating), 2) AS Average_Rating
FROM employees_cleaned e
JOIN performance_cleaned p
ON e.Employee_ID = p.Employee_ID
GROUP BY e.Department
ORDER BY Average_Rating DESC;

# Employees Below Average Performance Rating
SELECT
e.Employee_ID,
e.Employee_Name,
e.Department,
p.Performance_Rating
FROM employees_cleaned e
JOIN performance_cleaned p
ON e.Employee_ID = p.Employee_ID
WHERE p.Performance_Rating < (
SELECT AVG(Performance_Rating)
FROM performance_cleaned)
ORDER BY p.Performance_Rating;

# Top 2 Employees with Highest Overtime in Each Department
WITH Employee_Overtime AS (
SELECT
e.Employee_Name,
e.Department,
p.Overtime_Hours,
ROW_NUMBER() OVER (
PARTITION BY e.Department
ORDER BY p.Overtime_Hours DESC
) AS Row_Num
FROM employees_cleaned e
JOIN performance_cleaned p
	ON e.Employee_ID = p.Employee_ID
)
SELECT *
FROM Employee_Overtime
WHERE Row_Num <= 2;

# Employees with High Overtime and Low Performance
SELECT
    e.Employee_ID,
    e.Employee_Name,
    e.Department,
    p.Overtime_Hours,
    p.Performance_Rating
FROM employees_cleaned e
JOIN performance_cleaned p
ON e.Employee_ID = p.Employee_ID
WHERE p.Overtime_Hours > (
SELECT AVG(Overtime_Hours)
FROM performance_cleaned
)
AND p.Performance_Rating < 3
ORDER BY p.Overtime_Hours DESC;

# Employee Count by Job Role
SELECT
Job_Role,
COUNT(*) AS Total_Employees
FROM employees_cleaned
GROUP BY Job_Role
ORDER BY Total_Employees DESC;

# Highest Salary in Each Department
SELECT
Department,
MAX(Monthly_Salary) AS Highest_Salary
FROM employees_cleaned
GROUP BY Department
ORDER BY Highest_Salary DESC;

# Employees Earning Above Company Average Salary
SELECT
Employee_Name,
Department,
Monthly_Salary
FROM employees_cleaned
WHERE Monthly_Salary > (
SELECT AVG(Monthly_Salary)
FROM employees_cleaned
)
ORDER BY Monthly_Salary DESC;

# Average Working Hours by Department
SELECT
e.Department,
ROUND(AVG(a.Working_Hours), 2) AS Average_Working_Hours
FROM employees_cleaned e
JOIN attendance_cleaned a
ON e.Employee_ID = a.Employee_ID
GROUP BY e.Department
ORDER BY Average_Working_Hours DESC;

# Attendance Status by Department
SELECT
e.Department,
a.Status,
COUNT(*) AS Total_Records
FROM employees_cleaned e
JOIN attendance_cleaned a
ON e.Employee_ID = a.Employee_ID
GROUP BY e.Department, a.Status
ORDER BY e.Department;

# Employees with the Highest Number of Absences
SELECT
    e.Employee_ID,
    e.Employee_Name,
    e.Department,
    SUM(a.Is_Absent) AS Total_Absences
FROM employees_cleaned e
JOIN attendance_cleaned a
    ON e.Employee_ID = a.Employee_ID
GROUP BY
e.Employee_ID,
e.Employee_Name,
e.Department
ORDER BY Total_Absences DESC
LIMIT 10;

# Performance Rating Distribution
SELECT
Performance_Rating,
COUNT(*) AS Employee_Count
FROM performance_cleaned
GROUP BY Performance_Rating
ORDER BY Performance_Rating;

# Average Overtime Hours by Department
SELECT
e.Department,
ROUND(AVG(p.Overtime_Hours), 2) AS Average_Overtime
FROM employees_cleaned e
JOIN performance_cleaned p
ON e.Employee_ID = p.Employee_ID
GROUP BY e.Department
ORDER BY Average_Overtime DESC;

# Resigned Employee Details
SELECT
    Employee_ID,
    Employee_Name,
    Department,
    Joining_Date,
    Resignation_Date,
    Resignation_Reason
FROM employees_cleaned
WHERE Employment_Status = 'Resigned'
ORDER BY Resignation_Date DESC;

#– Department Manager and Employee Count
SELECT
d.Department,
d.Department_Manager,
COUNT(e.Employee_ID) AS Total_Employees
FROM departments_cleaned d
LEFT JOIN employees_cleaned e
ON d.Department = e.Department
GROUP BY
d.Department,
d.Department_Manager
ORDER BY Total_Employees DESC;

# Active Employees by Department
SELECT
Department,
COUNT(*) AS Active_Employees
FROM employees_cleaned
WHERE Employment_Status = 'Active'
GROUP BY Department
ORDER BY Active_Employees DESC;

# Minimum and Maximum Salary by Department
SELECT
Department,
MIN(Monthly_Salary) AS Minimum_Salary,
MAX(Monthly_Salary) AS Maximum_Salary
FROM employees_cleaned
GROUP BY Department;

# Employees Joined in Each Year
SELECT
YEAR(Joining_Date) AS Joining_Year,
COUNT(*) AS Employees_Joined
FROM employees_cleaned
GROUP BY YEAR(Joining_Date)
ORDER BY Joining_Year;

#Query 30 – Employees Who Have Not Resigned
SELECT
Employee_ID,
Employee_Name,
Department,
Joining_Date,
Monthly_Salary
FROM employees_cleaned
WHERE Resignation_Date IS NULL
ORDER BY Joining_Date;

# Attendance Rate for Each Employee
SELECT
e.Employee_ID,
e.Employee_Name,
e.Department,
ROUND(AVG(a.Is_Attended) * 100, 2) AS Attendance_Rate
FROM employees_cleaned e
JOIN attendance_cleaned a
ON e.Employee_ID = a.Employee_ID
GROUP BY
e.Employee_ID,
e.Employee_Name,
e.Department
ORDER BY Attendance_Rate DESC;

# Department-wise Attendance Rate
SELECT
e.Department,
ROUND(AVG(a.Is_Attended) * 100, 2) AS Attendance_Rate
FROM employees_cleaned e
JOIN attendance_cleaned a
ON e.Employee_ID = a.Employee_ID
GROUP BY e.Department
ORDER BY Attendance_Rate DESC;

# Employees with More Than 5 Absences
SELECT
e.Employee_ID,
e.Employee_Name,
e.Department,
SUM(a.Is_Absent) AS Total_Absences
FROM employees_cleaned e
JOIN attendance_cleaned a
ON e.Employee_ID = a.Employee_ID
GROUP BY
e.Employee_ID,
e.Employee_Name,
e.Department
HAVING SUM(a.Is_Absent) > 5
ORDER BY Total_Absences DESC;

# Average Performance Rating by Job Role
SELECT
e.Job_Role,
ROUND(AVG(p.Performance_Rating), 2) AS Average_Rating
FROM employees_cleaned e
JOIN performance_cleaned p
ON e.Employee_ID = p.Employee_ID
GROUP BY e.Job_Role
ORDER BY Average_Rating DESC;

# Department-wise Overtime and Performance Comparison
SELECT
e.Department,
ROUND(AVG(p.Overtime_Hours), 2) AS Average_Overtime,
ROUND(AVG(p.Performance_Rating), 2) AS Average_Performance
FROM employees_cleaned e
JOIN performance_cleaned p
ON e.Employee_ID = p.Employee_ID
GROUP BY e.Department
ORDER BY Average_Overtime DESC;

# Rank Employees by Salary
SELECT
Employee_Name,
Department,
Monthly_Salary,
DENSE_RANK() OVER (
ORDER BY Monthly_Salary DESC
) AS Salary_Rank
FROM employees_cleaned;

# Rank Employees by Performance Within Each Department
SELECT
    e.Employee_Name,
    e.Department,
    p.Performance_Rating,
    DENSE_RANK() OVER (
	PARTITION BY e.Department
	ORDER BY p.Performance_Rating DESC
    ) AS Performance_Rank
FROM employees_cleaned e
JOIN performance_cleaned p
    ON e.Employee_ID = p.Employee_ID;
    
# Second Highest Salary
SELECT MAX(Monthly_Salary) AS Second_Highest_Salary
FROM employees_cleaned
WHERE Monthly_Salary < (
SELECT MAX(Monthly_Salary)
FROM employees_cleaned);

# Employees Earning More Than Their Department Average
SELECT
Employee_Name,
Department,
Monthly_Salary
FROM (
SELECT
Employee_Name,
Department,
Monthly_Salary,
AVG(Monthly_Salary) OVER (
PARTITION BY Department
) AS Department_Average
FROM employees_cleaned
) AS Salary_Data
WHERE Monthly_Salary > Department_Average;

# Running Total of Employee Attendance Records by Date
SELECT
Attendance_Date,
COUNT(*) AS Daily_Records,
SUM(COUNT(*)) OVER (
ORDER BY Attendance_Date
) AS Running_Total
FROM attendance_cleaned
GROUP BY Attendance_Date
ORDER BY Attendance_Date;

# Employees with More Than 10 Hours of Overtime
SELECT
e.Employee_Name,
e.Department,
p.Overtime_Hours
FROM employees_cleaned e
JOIN performance_cleaned p
ON e.Employee_ID = p.Employee_ID
WHERE p.Overtime_Hours > 10
ORDER BY p.Overtime_Hours DESC;

#Query 42 – Department with the Highest Average Salary
SELECT
Department,
ROUND(AVG(Monthly_Salary), 2) AS Average_Salary
FROM employees_cleaned
GROUP BY Department
ORDER BY Average_Salary DESC
LIMIT 1;

# Monthly Resignation Trend
SELECT
DATE_FORMAT(Resignation_Date, '%Y-%m') AS Resignation_Month,
COUNT(*) AS Total_Resignations
FROM employees_cleaned
WHERE Resignation_Date IS NOT NULL
GROUP BY DATE_FORMAT(Resignation_Date, '%Y-%m')
ORDER BY Resignation_Month;

# Employees with Perfect Attendance
SELECT
e.Employee_ID,
e.Employee_Name,
e.Department,
ROUND(AVG(a.Is_Attended) * 100, 2) AS Attendance_Rate
FROM employees_cleaned e
JOIN attendance_cleaned a
ON e.Employee_ID = a.Employee_ID
GROUP BY
e.Employee_ID,
e.Employee_Name,
e.Department
HAVING AVG(a.Is_Attended) = 1;

# Employees with Low Performance and High Absences
SELECT
e.Employee_Name,
e.Department,
p.Performance_Rating,
SUM(a.Is_Absent) AS Total_Absences
FROM employees_cleaned e
JOIN performance_cleaned p
ON e.Employee_ID = p.Employee_ID
JOIN attendance_cleaned a
ON e.Employee_ID = a.Employee_ID
GROUP BY
e.Employee_ID,
e.Employee_Name,
e.Department,
    p.Performance_Rating
HAVING p.Performance_Rating < 3
AND SUM(a.Is_Absent) > 5;

# Department-wise Active Employee Salary Cost
SELECT
Department,
SUM(Monthly_Salary) AS Monthly_Salary_Cost
FROM employees_cleaned
WHERE Employment_Status = 'Active'
GROUP BY Department
ORDER BY Monthly_Salary_Cost DESC;

# Employees Who Joined and Resigned Within One Year
SELECT
Employee_ID,
Employee_Name,
Department,
Joining_Date,
Resignation_Date
FROM employees_cleaned
WHERE Resignation_Date IS NOT NULL
AND DATEDIFF(Resignation_Date, Joining_Date) < 365;

# Department-wise Employee Performance Categories
SELECT
e.Department,
CASE
WHEN p.Performance_Rating >= 4 THEN 'High'
WHEN p.Performance_Rating >= 3 THEN 'Average'
ELSE 'Low'
END AS Performance_Category,
COUNT(*) AS Employee_Count
FROM employees_cleaned e
JOIN performance_cleaned p
ON e.Employee_ID = p.Employee_ID
GROUP BY
    e.Department,
    Performance_Category
ORDER BY e.Department;

# Employees Whose Salary Is Above Their Job Role Average
SELECT
Employee_Name,
Job_Role,
Monthly_Salary
FROM (
SELECT
Employee_Name,
Job_Role,
Monthly_Salary,
AVG(Monthly_Salary) OVER (
PARTITION BY Job_Role
) AS Role_Average
FROM employees_cleaned
) AS Role_Data
WHERE Monthly_Salary > Role_Average;

# Overall Workforce Summary
SELECT
COUNT(*) AS Total_Employees,
SUM(CASE WHEN Employment_Status = 'Active' THEN 1 ELSE 0 END) AS Active_Employees,
SUM(CASE WHEN Employment_Status = 'Resigned' THEN 1 ELSE 0 END) AS Resigned_Employees,
ROUND(AVG(Monthly_Salary), 2) AS Average_Salary
FROM employees_cleaned;