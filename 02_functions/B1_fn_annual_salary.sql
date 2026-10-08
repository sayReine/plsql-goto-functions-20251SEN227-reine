
CREATE OR REPLACE FUNCTION fn_annual_salary (
  p_emp_id IN employees.emp_id%TYPE
) RETURN NUMBER
IS
  v_monthly employees.monthly_salary%TYPE;
BEGIN
  IF p_emp_id IS NULL THEN
    RAISE_APPLICATION_ERROR(-20001, 'Employee ID cannot be NULL');
  END IF;

  SELECT monthly_salary
    INTO v_monthly
    FROM employees
   WHERE emp_id = p_emp_id;

  IF v_monthly IS NULL OR v_monthly < 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Invalid monthly salary for employee ' || p_emp_id);
  END IF;

  RETURN v_monthly * 12;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20003, 'Employee ' || p_emp_id || ' not found');
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20004, 'More than one row found for employee ' || p_emp_id);
  WHEN OTHERS THEN
    
    IF SQLCODE BETWEEN -20999 AND -20000 THEN
      RAISE;
    ELSE
      RAISE_APPLICATION_ERROR(-20009, 'Unexpected error in fn_annual_salary: ' || SQLERRM);
    END IF;
END fn_annual_salary;
/
SHOW ERRORS
