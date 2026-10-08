SET SERVEROUTPUT ON
SET DEFINE OFF

BEGIN
  FOR t IN (SELECT column_value AS tname
              FROM TABLE(sys.odcivarchar2list('EMPLOYEES', 'DEPARTMENTS'))) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.tname || ' PURGE';
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
          RAISE;
        END IF;
    END;
  END LOOP;
END;
/


CREATE TABLE departments (
  dept_id    NUMBER(4)    PRIMARY KEY,
  dept_name  VARCHAR2(50) NOT NULL
);

CREATE TABLE employees (
  emp_id          NUMBER(6)    PRIMARY KEY,
  first_name      VARCHAR2(30) NOT NULL,
  last_name       VARCHAR2(30) NOT NULL,
  dept_id         NUMBER(4),
  monthly_salary  NUMBER(10,2),
  hire_date       DATE
);

INSERT INTO departments VALUES (10, 'Finance');
INSERT INTO departments VALUES (20, 'Human Resources');
INSERT INTO departments VALUES (30, 'IT');


INSERT INTO employees VALUES (1, 'Alice',   'Mukamana',  10, 4500, DATE '2018-03-15');
INSERT INTO employees VALUES (2, 'Jean',    'Habimana',  20, 2800, DATE '2021-07-01');
INSERT INTO employees VALUES (3, 'Grace',   'Uwase',     10, 7200, DATE '2015-01-10');
INSERT INTO employees VALUES (4, 'Eric',    'Niyonzima', 30, 1500, DATE '2023-09-01');
INSERT INTO employees VALUES (5, 'Diane',   'Ingabire',  20, 5200, DATE '2019-11-20');


INSERT INTO employees VALUES (6, 'Patrick', 'Nshuti',    30, -500, DATE '2020-05-05'); 
INSERT INTO employees VALUES (7, 'Sandra',  'Kamanzi',   10, NULL, DATE '2022-02-14'); 
INSERT INTO employees VALUES (8, 'Olivier', 'Gatera',    20, 3000, DATE '2030-01-01');
INSERT INTO employees VALUES (9, 'Beata',   'Mutoni',    99, 4000, DATE '2017-08-30'); 

COMMIT;

SELECT COUNT(*) AS departments_loaded FROM departments;
SELECT COUNT(*) AS employees_loaded   FROM employees;