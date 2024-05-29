--01
SELECT TOP(5)
	e.EmployeeID, e.JobTitle, e.AddressID, AddressText 
FROM 
	Employees AS e
JOIN Addresses AS a ON a.AddressID = e.AddressID
ORDER BY
	AddressID

--02
SELECT TOP(50)
	e.FirstName, e.LastName, t.[Name], a.AddressText
FROM Employees AS e
JOIN Addresses AS a ON a.AddressID = e.AddressID
JOIN Towns AS t ON a.TownID = t.TownID
ORDER BY
	FirstName, LastName

--03
SELECT EmployeeID, FirstName, LastName, [Name]
FROM Employees AS e
JOIN Departments as d ON d.DepartmentID = e.DepartmentID
WHERE 
	[Name] = 'Sales'
ORDER BY
	EmployeeID

--04
SELECT TOP(5)
	EmployeeID, FirstName, Salary, [Name]
FROM Employees AS e
JOIN Departments as d ON d.DepartmentID = e.DepartmentID
WHERE 
	Salary > 15000
ORDER BY
	e.DepartmentID

--05
SELECT TOP(3) EmployeeID, FirstName
FROM Employees
WHERE 
	EmployeeID NOT IN 
		(SELECT DISTINCT EmployeeID FROM EmployeesProjects)

SELECT TOP(3) e.EmployeeID, FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
WHERE ep.EmployeeID IS NULL

WITH EmployeesWithoutProjects AS (
	SELECT e.EmployeeID, FirstName
	FROM Employees AS e
	EXCEPT
	SELECT e.EmployeeID, FirstName
	FROM Employees AS e
	JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID)

SELECT TOP(3) EmployeeID, FirstName
FROM EmployeesWithoutProjects 

--06
SELECT
	FirstName, LastName, HireDate, [Name]
FROM Employees AS e
JOIN Departments as d on e.DepartmentID = d.DepartmentID
WHERE	
	HireDate > '1999-01-01' AND
	[Name] IN ('Sales', 'Finance')
ORDER BY
	HireDate

--07
SELECT TOP(5)
	e.EmployeeID, FirstName, [Name] AS [ProjectName]
FROM Employees AS e
JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
WHERE StartDate > '2002-08-13' AND
	EndDate IS NULL
ORDER BY 
	e.EmployeeID

--08
SELECT e.EmployeeID, FirstName, [Project Name] =
CASE
	WHEN DATEPART(YEAR, StartDate) > 2004 THEN NULL
	ELSE [Name]
END
FROM EmployeesProjects AS ep
JOIN Projects AS p ON ep.ProjectID = p.ProjectID
JOIN Employees AS e on e.EmployeeID = ep.EmployeeID
WHERE 
	e.EmployeeID = 24

--09
SELECT 
	emp.EmployeeID, emp.FirstName, mgr.EmployeeID, mgr.FirstName
FROM Employees AS emp
JOIN Employees AS mgr ON emp.ManagerID = mgr.EmployeeID
WHERE
	emp.ManagerID IN (3, 7)
ORDER BY
	emp.EmployeeID

--10
SELECT TOP(50)
	emp.EmployeeID,
	CONCAT_WS(' ', emp.FirstName, emp.LastName) AS EmployeeName,
	CONCAT_WS(' ', mgr.FirstName, mgr.LastName) AS ManagerName,
	d.[Name] AS DepartmentName
FROM Employees AS emp
JOIN Employees AS mgr ON emp.ManagerID = mgr.EmployeeID
JOIN Departments AS d on d.DepartmentID = emp.DepartmentID
ORDER BY emp.EmployeeID

--11
SELECT TOP 1 AVG(Salary) MinAvarageSalary
FROM Employees 
GROUP BY
	DepartmentID
ORDER BY MinAvarageSalary

--16
SELECT COUNT(*)
FROM Countries
WHERE CountryCode NOT IN 
	(SELECT DISTINCT CountryCode FROM MountainsCountries)

--17
SELECT TOP (5)
	CountryName,
	MAX(Elevation) AS HighestPeakElevation,
	MAX(r.[Length]) AS LongestRiverLength
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers AS r ON r.Id = cr.RiverId 
LEFT JOIN MountainsCountries AS mc ON mc.CountryCode = c.CountryCode
LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
LEFT JOIN Peaks AS p ON p.MountainId = m.Id
GROUP BY 
	CountryName
ORDER BY
	HighestPeakElevation DESC,
	LongestRiverLength DESC,
	CountryName

--18
WITH PeaksRankedByElevation AS 
(
	SELECT
		c.CountryName,
		p.PeakName,
		p.Elevation,
		m.MountainRange,
		DENSE_RANK() OVER
			(PARTITION BY c.CountryName ORDER BY Elevation DESC) AS PeakRank
	FROM Countries AS c
	LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
	LEFT JOIN Mountains AS m ON m.Id = mc.MountainId
	LEFT JOIN Peaks AS p ON m.Id = p.MountainId
)

SELECT TOP(5)
	CountryName AS Country,
	ISNULL(PeakName, '(no highest peak)') AS [Highest Peak Name],
	ISNULL(Elevation, 0) AS [Highest Peak Elevation],
	ISNULL(MountainRange, '(no mountain)') AS Mountain
FROM PeaksRankedByElevation
WHERE PeakRank = 1
ORDER BY 
	CountryName, [Highest Peak Name]