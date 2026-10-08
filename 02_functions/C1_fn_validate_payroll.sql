
CREATE OR REPLACE FUNCTION fn_validate_payroll (
  p_emp_id IN employees.emp_id%TYPE
) RETURN VARCHAR2
IS
  v_dept_id  employees.dept_id%TYPE;
  v_salary   employees.monthly_salary%TYPE;
  v_hire     employees.hire_date%TYPE;
  v_annual   NUMBER;
  v_tax      NUMBER;
  v_msg      VARCHAR2(200);
BEGIN
  SELECT dept_id, monthly_salary, hire_date
    INTO v_dept_id, v_salary, v_hire
    FROM employees
   WHERE emp_id = p_emp_id;

  IF v_salary IS NULL OR v_salary <= 0 THEN
    v_msg := 'Salary is missing or not positive';
    GOTO invalid_payroll;
  END IF;


  IF v_hire IS NULL THEN
    v_msg := 'Hire date is missing';
    GOTO invalid_payroll;
  ELSIF v_hire > SYSDATE THEN
    v_msg := 'Hire date is in the future';
    GOTO invalid_payroll;
  END IF;

  IF v_dept_id IS NULL THEN
    v_msg := 'No department assigned';
    GOTO invalid_payroll;
  ELSIF fn_dept_name(v_dept_id) = 'Unknown Department' THEN
    v_msg := 'Department ' || v_dept_id || ' does not exist';
    GOTO invalid_payroll;
  END IF;

  v_annual := fn_annual_salary(p_emp_id);
  v_tax    := fn_calculate_tax(v_annual);
  IF v_tax >= v_annual THEN
    v_msg := 'Tax is not lower than annual salary';
    GOTO invalid_payroll;
  END IF;

  RETURN 'VALID';

  <<invalid_payroll>>
  RETURN 'INVALID: ' || v_msg;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN 'INVALID: Employee not found';
  WHEN OTHERS THEN
    RETURN 'INVALID: Unexpected error - ' || SQLERRM;
END fn_validate_payroll;
/
SHOW ERRORS
