CREATE OR REPLACE FUNCTION fn_years_of_service (
  p_emp_id IN employees.emp_id%TYPE
) RETURN NUMBER
IS
  v_hire employees.hire_date%TYPE;
BEGIN
  IF p_emp_id IS NULL THEN
    RAISE_APPLICATION_ERROR(-20011, 'Employee ID cannot be NULL');
  END IF;

  SELECT hire_date
    INTO v_hire
    FROM employees
   WHERE emp_id = p_emp_id;

  IF v_hire IS NULL OR v_hire > SYSDATE THEN
    RAISE_APPLICATION_ERROR(-20012, 'Invalid hire date for employee ' || p_emp_id);
  END IF;

  RETURN TRUNC(MONTHS_BETWEEN(SYSDATE, v_hire) / 12);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20013, 'Employee ' || p_emp_id || ' not found');
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20014, 'More than one row found for employee ' || p_emp_id);
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN
      RAISE;
    ELSE
      RAISE_APPLICATION_ERROR(-20019, 'Unexpected error in fn_years_of_service: ' || SQLERRM);
    END IF;
END fn_years_of_service;
/
SHOW ERRORS
