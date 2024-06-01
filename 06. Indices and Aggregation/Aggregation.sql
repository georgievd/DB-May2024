--01
SELECT COUNT(*)
FROM WizzardDeposits

--02
SELECT 
	MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits

--03
SELECT 
	DepositGroup, 
	MAX(MagicWandSize) AS LongestMagicWand
FROM WizzardDeposits
GROUP BY DepositGroup


SELECT DepositGroup, MagicWandSize
FROM
(SELECT 
	DepositGroup, MagicWandSize,
	ROW_NUMBER() OVER 
		(PARTITION BY DepositGroup ORDER BY MagicWandSize DESC) AS RankedMagicWands
FROM WizzardDeposits) AS SubQuery
WHERE RankedMagicWands = 1

--04
SELECT TOP 2
	DepositGroup
FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

--05
SELECT 
	DepositGroup, SUM(DepositAmount) AS DepositAmounts
FROM WizzardDeposits
GROUP BY DepositGroup

--06
SELECT 
	DepositGroup, SUM(DepositAmount) AS DepositAmounts
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

--07
SELECT 
	DepositGroup, SUM(DepositAmount) AS TotalDepositAmount
FROM WizzardDeposits
WHERE 
	MagicWandCreator = 'Ollivander family'
GROUP BY 
	DepositGroup
HAVING
	SUM(DepositAmount) < 150000
ORDER BY
	TotalDepositAmount DESC

--08
SELECT 
	DepositGroup, MagicWandCreator, 
	MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits
GROUP BY 
	MagicWandCreator, DepositGroup 
ORDER BY
	MagicWandCreator, DepositGroup 

--09
SELECT 
	AgeCategory, COUNT(*) AS WizzardCount
FROM 
(
	SELECT 
		CASE
			WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
			WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
			WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
			WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
			WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
			WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
			WHEN Age > 60 THEN '[61+]'  
		END AS AgeCategory
			FROM WizzardDeposits 
) AS NestedQuery
GROUP BY
	AgeCategory

--10
SELECT FirstLetter FROM 
(
	SELECT 
		 SUBSTRING(FirstName, 1, 1) AS FirstLetter
	FROM WizzardDeposits
	WHERE 
		DepositGroup = 'Troll Chest'
) AS SubQuery
GROUP BY FirstLetter

--11
SELECT
	DepositGroup, IsDepositExpired,
	AVG(DepositInterest) AS AverageInterest
FROM WizzardDeposits
WHERE DepositStartDate > '1985-01-01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

--12
SELECT SUM([Difference]) AS SumDifference
FROM
(
SELECT 
	FirstName AS HostWizzard,
	DepositAmount AS HostWizzardDeposit,
	LEAD(FirstName) OVER (ORDER BY Id) AS GuestWizzard,
	LEAD([DepositAmount]) OVER (ORDER BY Id) AS GuestWizzardDeposit,
	(DepositAmount - LEAD([DepositAmount]) OVER (ORDER BY Id)) AS [Difference]
FROM WizzardDeposits
) AS SubQuery


--13
SELECT 
	DepartmentID, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID

--14
SELECT 
	DepartmentID, MIN(Salary) AS MinSalary
FROM Employees
WHERE
	DepartmentID IN (2, 5, 7) AND
	HireDate > '2000-01-01'
GROUP BY DepartmentID

--15
SELECT * INTO RichEmployees
FROM Employees
WHERE Salary > 30000

DELETE 
FROM RichEmployees
WHERE ManagerID = 42

UPDATE RichEmployees
SET Salary = Salary + 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary)
FROM RichEmployees
GROUP BY DepartmentID

--16
SELECT 
	DepartmentID, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--17
SELECT COUNT(Salary) AS SalaryCount
FROM Employees
WHERE ManagerID IS NULL

--18
SELECT DepartmentID, ThirRanking
FROM
	(SELECT 
		DepartmentID, 
		MAX(Salary) AS ThirRanking,
		DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRanking
	FROM Employees
	GROUP BY DepartmentID, Salary) AS SubQuery
WHERE SubQuery.SalaryRanking = 3

--19
WITH DepartmentAvarageSalaries AS
(
	SELECT 
		DepartmentID, AVG(Salary) AS AvarageSalary
	FROM Employees
	GROUP BY DepartmentID
)
SELECT TOP 10
	FirstName, LastName, e.DepartmentID
FROM Employees AS e
JOIN DepartmentAvarageSalaries AS das ON das.DepartmentID = e.DepartmentID
WHERE e.Salary > das.AvarageSalary
ORDER BY e.DepartmentID


