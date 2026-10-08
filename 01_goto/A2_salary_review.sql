
SET SERVEROUTPUT ON

DECLARE
  CURSOR c_emp IS
    SELECT emp_id, first_name, last_name, monthly_salary
      FROM employees
     ORDER BY emp_id;
  v_pct   NUMBER;
  v_new   NUMBER;
  v_msg   VARCHAR2(40);
  v_count NUMBER := 0;
  e_no_employees EXCEPTION;
BEGIN
  FOR r IN c_emp LOOP
    v_count := v_count + 1;
    BEGIN                          
      v_pct := 0;

      
      IF r.monthly_salary IS NULL OR r.monthly_salary <= 0 THEN
        GOTO invalid_salary;
      END IF;

      
      IF r.monthly_salary < 2000 THEN
        GOTO big_raise;
      ELSIF r.monthly_salary < 5000 THEN
        GOTO standard_raise;
      ELSE
        GOTO no_raise;
      END IF;

      <<big_raise>>
      v_pct := 10;
      v_msg := 'Priority review';
      GOTO show_result;

      <<standard_raise>>
      v_pct := 5;
      v_msg := 'Standard review';
      GOTO show_result;

      <<no_raise>>
      v_pct := 0;
      v_msg := 'No adjustment';
      GOTO show_result;

      <<invalid_salary>>
      DBMS_OUTPUT.PUT_LINE('Emp ' || r.emp_id || ' ' || r.first_name || ' ' || r.last_name ||
                           ' -> SKIPPED (invalid salary)');
      GOTO next_employee;

      <<show_result>>
      v_new := r.monthly_salary * (1 + v_pct / 100);
      DBMS_OUTPUT.PUT_LINE('Emp ' || r.emp_id || ' ' || RPAD(r.first_name || ' ' || r.last_name, 18) ||
                           ' current=' || TO_CHAR(r.monthly_salary, 'FM99,990.00') ||
                           ' raise=' || v_pct || '%' ||
                           ' new=' || TO_CHAR(v_new, 'FM99,990.00') ||
                           ' (' || v_msg || ')');

      <<next_employee>>
      NULL;  
    EXCEPTION
      WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Emp ' || r.emp_id || ' -> ERROR: value/format problem');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Emp ' || r.emp_id || ' -> ERROR ' || SQLCODE || ': ' || SQLERRM);
    END;
  END LOOP;

  IF v_count = 0 THEN
    RAISE e_no_employees;
  END IF;
  DBMS_OUTPUT.PUT_LINE('Reviewed ' || v_count || ' employees.');
EXCEPTION
  WHEN e_no_employees THEN
    DBMS_OUTPUT.PUT_LINE('A2: no employees found - run 00_setup/create_tables.sql first');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('A2 failed: ' || SQLCODE || ' ' || SQLERRM);
END;
/
