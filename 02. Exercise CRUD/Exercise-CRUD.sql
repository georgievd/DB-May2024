USE SoftUni
GO
--02. 
SELECT * FROM Departments
--03
SELECT [Name] FROM Departments
-- 04
SELECT FirstName, LastName, Salary FROM Employees
-- 05
SELECT FirstName AS 'bla-bla', MiddleName, LastName FROM Employees
--06
SELECT CONCAT(FirstName, '.', LastName, '@softuni.bg') 
					AS 'Full Email Address'
FROM Employees

--07
SELECT DISTINCT Salary FROM Employees

--08
SELECT *
FROM Employees
WHERE JobTitle = 'Sales Representative'

--09
SELECT FirstName, LastName, JobTitle
FROM Employees
WHERE Salary BETWEEN 20000 AND 30000

SELECT FirstName, LastName, JobTitle
FROM Employees
WHERE Salary >= 20000 
	AND Salary <= 30000

--10
SELECT CONCAT_WS(' ', FirstName, MiddleName, LastName) AS 'Full Name'
FROM Employees
WHERE Salary = 25000 OR
		Salary = 14000 OR
		Salary = 12500 OR
		Salary = 23600

SELECT CONCAT_WS(' ', FirstName, MiddleName, LastName) AS 'Full Name'
FROM Employees
WHERE Salary IN (25000, 14000, 12500, 23600)


--11. 
SELECT FirstName, LastName
FROM Employees
WHERE ManagerID IS NULL

--12
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC

--13
SELECT TOP(5) FirstName, LastName
FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC

--14
SELECT FirstName, LastName
FROM Employees
WHERE DepartmentID != 4

--15
SELECT * 
FROM Employees
	ORDER BY Salary DESC,
	FirstName,
	LastName DESC,
	MiddleName

--16
CREATE VIEW V_EmployeesSalaries  AS
(
	SELECT FirstName, LastName, Salary
	FROM Employees
)

--17
CREATE VIEW V_EmployeeNameJobTitle  AS
(
	SELECT 
	CONCAT(FirstName, ' ', COALESCE(MiddleName, ''), ' ', LastName) AS 'Full Name',
	JobTitle
	FROM Employees
)

--18
SELECT DISTINCT JobTitle
FROM Employees

--19
SELECT TOP(10) * 
FROM Projects
ORDER BY StartDate, [Name]

--20
SELECT TOP(7) FirstName, LastName, HireDate
FROM Employees
ORDER BY HireDate DESC

--21
SELECT * FROM Departments -- Result: 1, 2, 4, 11

BEGIN TRANSACTION
UPDATE 
Employees
SET Salary = Salary * 1.12
WHERE DepartmentID IN (1, 2, 4, 11)

SELECT FirstName, LastName, Salary 
FROM Employees
WHERE DepartmentID IN (1, 2, 4, 11)
ROLLBACK TRANSACTION --This returns the database to the previous state

SELECT FirstName, LastName, Salary 
FROM Employees
WHERE DepartmentID IN (1, 2, 4, 11)

--24
USE Geography
GO
SELECT CountryName, CountryCode,
CASE
	WHEN CurrencyCode = 'EUR' THEN 'Euro'
	ELSE 'Not Euro'
END AS Currency
FROM Countries
ORDER BY CountryName

--25
USE Diablo
GO
SELECT [Name] FROM Characters
ORDER BY [Name]