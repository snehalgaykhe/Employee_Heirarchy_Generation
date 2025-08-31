-- Create Database
CREATE DATABASE IF NOT EXISTS FinalProjectSQLH;
USE FinalProjectSQLH;

-- Employee Master Table
DROP TABLE IF EXISTS EMPLOYEE_MASTER;
CREATE TABLE EMPLOYEE_MASTER (
    EMPLOYEEID VARCHAR(20) PRIMARY KEY,
    REPORTINGTO VARCHAR(20),
    EMAILID VARCHAR(255)
);

-- Sample Data
INSERT INTO EMPLOYEE_MASTER (EMPLOYEEID, REPORTINGTO, EMAILID)
VALUES ('H1', NULL, 'john.doe@example.com'),
       ('H2', NULL, 'jane.smith@domain.com'),
       ('H3', 'H1', 'alice.jones@example.com'),
       ('H4', 'H1', 'bob.white@example.com'),
       ('H5', 'H3', 'charlie.brown@example.com'),
       ('H6', 'H3', 'david.green@example.com'),
       ('H7', 'H4', 'emily.gray@example.com'),
       ('H8', 'H4', 'frankwilson@example.com'),
       ('H9', 'H5', 'george.harris@example.com'),
       ('H10', 'H5', 'hannah.taylor@example.com'),
       ('H11', 'H6', 'irene.martin@example.com'),
       ('H12', 'H6', 'jackroberts@example.com'),
       ('H13', 'H7', 'kate.evans@example.com'),
       ('H14', 'H7', 'laura.hall@example.com'),
       ('H15', 'H8', 'mike.anderson@example.com'),
       ('H16', 'H8', 'natalie.c1ark@example.com'),
       ('H17', 'H9', 'oliver.davis@example.com'),
       ('H18', 'H9', 'peter.edwards@example.com'),
       ('H19', 'H10', 'quinn.fisher@example.com'),
       ('H20', 'H10', 'rachel.garcia@examp1e.com'),
       ('H21', 'H11', 'sarah.hernandez@example.com'),
       ('H22', 'H11', 'thomas.1ee@example.com'),
       ('H23', 'H12', 'ursula.lopez@example.com'),
       ('H24', 'H12', 'victor.martinez@example.com'),
       ('H25', 'H13', 'william.nguyen@example.com'),
       ('H26', 'H13', 'xavier.ortiz@example.com'),
       ('H27', 'H14', 'yvonne.perez@example.com'),
       ('H28', 'H14', 'zoe.quinn@example.com'),
       ('H29', 'H15', 'adam.robinson@example.com'),
       ('H30', 'H15', 'barbara.smith@examp1e.com');

-- Hierarchy Table
DROP TABLE IF EXISTS Employee_Hierarchy;
CREATE TABLE Employee_Hierarchy (
    EMPLOYEEID VARCHAR(20) PRIMARY KEY,
    REPORTINGTO VARCHAR(20),
    EMAILID VARCHAR(255),
    LEVEL INT,
    FIRSTNAME VARCHAR(100),
    LASTNAME VARCHAR(100)
);

-- Stored Procedure
DELIMITER $$

DROP PROCEDURE IF EXISTS SP_hierarchyF$$
CREATE PROCEDURE SP_hierarchyF()
BEGIN
    -- Clear table safely
    TRUNCATE TABLE Employee_Hierarchy;

    -- Insert using recursive CTE
    INSERT INTO Employee_Hierarchy (EMPLOYEEID, REPORTINGTO, EMAILID, LEVEL, FIRSTNAME, LASTNAME)
    WITH RECURSIVE EmployeeCTE AS (
        -- Base Case (top level employees)
        SELECT 
            EMPLOYEEID,
            REPORTINGTO,
            EMAILID,
            CONCAT(UCASE(LEFT(
                CASE 
                    WHEN LOCATE('.', EMAILID) > 0 
                    THEN SUBSTRING_INDEX(EMAILID, '.', 1)
                    ELSE SUBSTRING_INDEX(EMAILID, '@', 1)
                END, 1)
            ), LCASE(SUBSTRING(
                CASE 
                    WHEN LOCATE('.', EMAILID) > 0 
                    THEN SUBSTRING_INDEX(EMAILID, '.', 1)
                    ELSE SUBSTRING_INDEX(EMAILID, '@', 1)
                END, 2))) AS FIRSTNAME,
            CONCAT(UCASE(LEFT(
                CASE 
                    WHEN LOCATE('.', EMAILID) > 0 
                    THEN SUBSTRING_INDEX(SUBSTRING_INDEX(EMAILID, '@', 1), '.', -1)
                    ELSE ''
                END, 1)
            ), LCASE(SUBSTRING(
                CASE 
                    WHEN LOCATE('.', EMAILID) > 0 
                    THEN SUBSTRING_INDEX(SUBSTRING_INDEX(EMAILID, '@', 1), '.', -1)
                    ELSE ''
                END, 2))) AS LASTNAME,
            1 AS LEVEL
        FROM EMPLOYEE_MASTER
        WHERE REPORTINGTO IS NULL
        
        UNION ALL
        
        -- Recursive Case
        SELECT 
            e.EMPLOYEEID,
            e.REPORTINGTO,
            e.EMAILID,
            CONCAT(UCASE(LEFT(
                CASE 
                    WHEN LOCATE('.', e.EMAILID) > 0 
                    THEN SUBSTRING_INDEX(e.EMAILID, '.', 1)
                    ELSE SUBSTRING_INDEX(e.EMAILID, '@', 1)
                END, 1)
            ), LCASE(SUBSTRING(
                CASE 
                    WHEN LOCATE('.', e.EMAILID) > 0 
                    THEN SUBSTRING_INDEX(e.EMAILID, '.', 1)
                    ELSE SUBSTRING_INDEX(e.EMAILID, '@', 1)
                END, 2))) AS FIRSTNAME,
            CONCAT(UCASE(LEFT(
                CASE 
                    WHEN LOCATE('.', e.EMAILID) > 0 
                    THEN SUBSTRING_INDEX(SUBSTRING_INDEX(e.EMAILID, '@', 1), '.', -1)
                    ELSE ''
                END, 1)
            ), LCASE(SUBSTRING(
                CASE 
                    WHEN LOCATE('.', e.EMAILID) > 0 
                    THEN SUBSTRING_INDEX(SUBSTRING_INDEX(e.EMAILID, '@', 1), '.', -1)
                    ELSE ''
                END, 2))) AS LASTNAME,
            ec.LEVEL + 1
        FROM EMPLOYEE_MASTER e
        INNER JOIN EmployeeCTE ec ON e.REPORTINGTO = ec.EMPLOYEEID
    )
    SELECT EMPLOYEEID, REPORTINGTO, EMAILID, LEVEL, FIRSTNAME, LASTNAME
    FROM EmployeeCTE;
END$$

DELIMITER ;

-- Run procedure
CALL SP_hierarchyF();

-- Check results
SELECT * FROM Employee_Hierarchy ORDER BY LEVEL, REPORTINGTO;
