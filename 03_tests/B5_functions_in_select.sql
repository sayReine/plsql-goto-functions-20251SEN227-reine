SET LINESIZE 200
SET PAGESIZE 50
COLUMN employee_name FORMAT A22
COLUMN department    FORMAT A18
COLUMN validation    FORMAT A48

PROMPT ===== Query 1: functions in the SELECT list (clean employees only) =====
SELECT e.emp_id,
       e.first_name || ' ' || e.last_name                  AS employee_name,
       fn_dept_name(e.dept_id)                             AS department,
       fn_annual_salary(e.emp_id)                          AS annual_salary,
       fn_years_of_service(e.emp_id)                       AS years_of_service,
       fn_calculate_tax(fn_annual_salary(e.emp_id))        AS annual_tax
  FROM employees e
 WHERE e.emp_id <= 5
 ORDER BY e.emp_id;

PROMPT ===== Query 2: validator in the SELECT list (all employees) =====
SELECT e.emp_id,
       e.first_name || ' ' || e.last_name AS employee_name,
       fn_validate_payroll(e.emp_id)      AS validation
  FROM employees e
 ORDER BY e.emp_id;

PROMPT ===== Query 3: function in WHERE - only valid payroll rows =====
SELECT e.emp_id,
       e.first_name || ' ' || e.last_name            AS employee_name,
       fn_annual_salary(e.emp_id)                    AS annual_salary
  FROM employees e
 WHERE fn_validate_payroll(e.emp_id) = 'VALID'
 ORDER BY annual_salary DESC;
