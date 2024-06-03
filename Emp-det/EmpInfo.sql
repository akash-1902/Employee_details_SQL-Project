-- Create the database
CREATE DATABASE company_db;

-- Use the new database
USE company_db;

-- Create the dep table
CREATE TABLE dep (
    depid INT PRIMARY KEY,
    dep_name VARCHAR(50),
    manager_id INT,
    manager_name VARCHAR(50),
    location VARCHAR(50)
);

-- Insert data into dep table
INSERT INTO dep (depid, dep_name, manager_id, manager_name, location) VALUES
(661101, 'Sales', 601, 'Sara Nelson', 'San Francisco'),
(661102, 'Marketing', 602, 'David Johnson', 'New York'),
(661103, 'HR', 603, 'Karen Smith', 'Chicago'),
(661104, 'Finance', 604, 'James Brown', 'Houston'),
(661105, 'IT', 605, 'Robert White', 'Phoenix'),
(661106, 'Operations', 606, 'Emily Harris', 'Philadelphia');

-- Create the empl table with foreign key to dep table
CREATE TABLE empl (
    Emp_ID INT PRIMARY KEY,
    F_name VARCHAR(30),
    L_name VARCHAR(30),
    Salary INT,
    Location VARCHAR(40),
    Email VARCHAR(50),
    Dept_ID INT,
    FOREIGN KEY (Dept_ID) REFERENCES dep(depid)
);

-- Insert data into empl table
INSERT INTO empl VALUES 
(601, "Alice", "Williams", 25000, "San Francisco", "alice.williams601@gmail.com", 661101),
(602, "Bob", "Miller", 28000, "New York", "bob.miller602@gmail.com", 661102),
(603, "Charlie", "Davis", 30000, "Chicago", "charlie.davis603@gmail.com", 661103),
(604, "Diana", "Lopez", 23000, "Houston", "diana.lopez604@gmail.com", 661104),
(605, "Ethan", "Martinez", 27000, "Phoenix", "ethan.martinez605@gmail.com", 661105),
(606, "Fiona", "Clark", 26000, "Philadelphia", "fiona.clark606@gmail.com", 661106),
(607, "George", "Rodriguez", 42000, "San Antonio", "george.rodriguez607@gmail.com", 661103),
(608, "Hannah", "Lewis", 35000, "San Diego", "hannah.lewis608@gmail.com", 661105),
(609, "Ian", "Walker", 34000, "Dallas", "ian.walker609@gmail.com", 661102),
(610, "Jenna", "Hall", 24000, "San Jose", "jenna.hall610@gmail.com", 661104),
(611, "Kevin", "Allen", 32000, "Austin", "kevin.allen611@gmail.com", 661101),
(612, "Lara", "Young", 33000, "Jacksonville", "lara.young612@gmail.com", 661102),
(613, "Mike", "King", 29000, "Fort Worth", "mike.king613@gmail.com", 661103),
(614, "Nina", "Scott", 31000, "Columbus", "nina.scott614@gmail.com", 661104),
(615, "Oliver", "Green", 28000, "Charlotte", "oliver.green615@gmail.com", 661105),
(616, "Paula", "Adams", 27000, "San Francisco", "paula.adams616@gmail.com", 661106);

-- Create the inc table with foreign key to empl table
CREATE TABLE inc (
    emp_id INT PRIMARY KEY,
    old_salary DECIMAL(10, 2),
    increment_amount DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    FOREIGN KEY (emp_id) REFERENCES empl(Emp_ID)
);

-- Insert data into inc table
INSERT INTO inc (emp_id, old_salary, increment_amount, new_salary) VALUES
(601, 25000, 2500, 27500),
(602, 28000, 2800, 30800),
(603, 30000, 3000, 33000),
(604, 23000, 2300, 25300),
(605, 27000, 2700, 29700),
(606, 26000, 2600, 28600),
(607, 42000, 4200, 46200),
(608, 35000, 3500, 38500),
(609, 34000, 3400, 37400),
(610, 24000, 2400, 26400),
(611, 32000, 3200, 35200),
(612, 33000, 3300, 36300),
(613, 29000, 2900, 31900),
(614, 31000, 3100, 34100),
(615, 28000, 2800, 30800),
(616, 27000, 2700, 29700);

-- Select all data from tables
SELECT * FROM empl;
SELECT * FROM dep;
SELECT * FROM inc;

-- Create backup tables
CREATE TABLE emplbup AS SELECT * FROM empl;
CREATE TABLE depbup AS SELECT * FROM dep;
CREATE TABLE incbup AS SELECT * FROM inc;

-- Create view for empl table
CREATE VIEW emplview AS SELECT * FROM empl;

-- Show indexes on empl table
SHOW INDEX FROM empl;

-- Create index on emp_id in empl table
CREATE INDEX id ON empl(Emp_ID);

-- Create stored procedure
DELIMITER //
CREATE PROCEDURE office_info()
BEGIN
    SELECT * FROM dep WHERE location IN ('San Francisco');
    SELECT location, COUNT(location) AS TOTAL FROM empl GROUP BY location;
    SELECT salary, location, COUNT(*) AS Total FROM empl GROUP BY salary, location;
END //
DELIMITER ;

-- Create trigger
DELIMITER //
CREATE TRIGGER after_increment_update
BEFORE UPDATE ON inc
FOR EACH ROW
BEGIN
    -- Update the new_salary in the inc table
    SET NEW.new_salary = NEW.old_salary + NEW.increment_amount;

    -- Update the salary in the empl table
    UPDATE empl
    SET salary = NEW.new_salary
    WHERE Emp_ID = NEW.emp_id;
END//
DELIMITER ;

-- Update increment amount and test the trigger
UPDATE inc SET increment_amount = 3000 WHERE emp_id = 601;

-- Select data to verify changes
SELECT * FROM inc;
SELECT * FROM empl;

-- Query to find the second highest salary
SELECT MAX(salary) AS second_highest_salary 
FROM empl 
WHERE salary < (SELECT MAX(salary) FROM empl);

-- Aggregate function queries

-- 1. Total salary expense
SELECT SUM(Salary) AS total_salary_expense FROM empl;

-- 2. Average salary
SELECT AVG(Salary) AS average_salary FROM empl;

-- 3. Highest salary
SELECT MAX(Salary) AS highest_salary FROM empl;

-- 4. Lowest salary
SELECT MIN(Salary) AS lowest_salary FROM empl;

-- 5. Number of employees in each location
SELECT Location, COUNT(*) AS number_of_employees 
FROM empl 
GROUP BY Location;

-- 6. Average salary by location
SELECT Location, AVG(Salary) AS average_salary_by_location 
FROM empl 
GROUP BY Location;

-- 7. Total salary by department
SELECT e.Dept_ID, d.dep_name, SUM(e.Salary) AS total_salary_by_department 
FROM empl e
JOIN dep d ON e.Dept_ID = d.depid
GROUP BY e.Dept_ID, d.dep_name;

-- 8. Count of employees by department
SELECT d.dep_name, COUNT(*) AS number_of_employees 
FROM empl e
JOIN dep d ON e.Dept_ID = d.depid
GROUP BY d.dep_name;

-- 9. Average increment amount
SELECT AVG(increment_amount) AS average_increment_amount FROM inc;

-- 10. Total increments given
SELECT SUM(increment_amount) AS total_increments_given FROM inc;

-- Subquery 1: Employees who earn more than the average salary
SELECT * FROM empl
WHERE Salary > (SELECT AVG(Salary) FROM empl);

-- Subquery 2: Department with the highest number of employees
SELECT depid, dep_name, location FROM dep
WHERE depid = (SELECT Dept_ID FROM empl
               GROUP BY Dept_ID
               ORDER BY COUNT(*) DESC
               LIMIT 1);


