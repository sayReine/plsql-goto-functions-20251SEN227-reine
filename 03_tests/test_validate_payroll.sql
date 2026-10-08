-- =====================================================================
-- test_validate_payroll.sql - tests C1 against all 9 employees
-- Employees 1-5 are clean; 6-9 contain one deliberate defect each.
-- =====================================================================
SET SERVEROUTPUT ON

DECLARE
  TYPE t_expect IS TABLE OF VARCHAR2(60) INDEX BY PLS_INTEGER;
  v_expected t_expect;
  v_actual   VARCHAR2(200);
BEGIN
  v_expected(1) := 'VALID';
  v_expected(2) := 'VALID';
  v_expected(3) := 'VALID';
  v_expected(4) := 'VALID';
  v_expected(5) := 'VALID';
  v_expected(6) := 'INVALID: Salary is missing or not positive';
  v_expected(7) := 'INVALID: Salary is missing or not positive';
  v_expected(8) := 'INVALID: Hire date is in the future';
  v_expected(9) := 'INVALID: Department 99 does not exist';

  FOR i IN 1 .. 9 LOOP
    v_actual := fn_validate_payroll(i);
    DBMS_OUTPUT.PUT_LINE('Emp ' || i || ': ' || RPAD(v_actual, 46) ||
                         CASE WHEN v_actual = v_expected(i) THEN ' PASS' ELSE ' FAIL' END);
  END LOOP;

  v_actual := fn_validate_payroll(999);
  DBMS_OUTPUT.PUT_LINE('Emp 999: ' || RPAD(v_actual, 46) ||
                       CASE WHEN v_actual = 'INVALID: Employee not found' THEN ' PASS' ELSE ' FAIL' END);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('TEST ABORTED: expected result missing for an employee');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TEST SCRIPT ABORTED: ' || SQLCODE || ' ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('Did you run create_tables.sql and all 02_functions scripts first?');
END;
/
