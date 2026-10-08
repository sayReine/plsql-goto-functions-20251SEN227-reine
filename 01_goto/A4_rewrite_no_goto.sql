
SET SERVEROUTPUT ON

PROMPT ===== A1 rewritten =====
DECLARE
  TYPE t_numbers IS VARRAY(6) OF NUMBER;
  v_nums        t_numbers := t_numbers(15, -4, 0, 8, -9, NULL);
  v_num         NUMBER;
  v_sign        VARCHAR2(10);
  v_parity      VARCHAR2(10);
  e_null_number EXCEPTION;
BEGIN
  FOR i IN 1 .. v_nums.COUNT LOOP
    BEGIN
      v_num := v_nums(i);

      IF v_num IS NULL THEN
        RAISE e_null_number;
      END IF;

      v_sign := CASE
                  WHEN v_num > 0 THEN 'Positive'
                  WHEN v_num < 0 THEN 'Negative'
                  ELSE 'Zero'
                END;

      IF MOD(v_num, 2) = 0 THEN
        v_parity := 'Even';
      ELSE
        v_parity := 'Odd';
      END IF;

      DBMS_OUTPUT.PUT_LINE('Number ' || RPAD(v_num, 4) || ' -> ' || v_sign || ', ' || v_parity);
    EXCEPTION
      WHEN e_null_number THEN
        DBMS_OUTPUT.PUT_LINE('Element ' || i || ' is NULL -> SKIPPED (cannot classify)');
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Element ' || i || ' -> ERROR ' || SQLCODE || ': ' || SQLERRM);
    END;
  END LOOP;
EXCEPTION
  WHEN SUBSCRIPT_BEYOND_COUNT THEN
    DBMS_OUTPUT.PUT_LINE('A1 rewrite failed: collection index out of range');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('A1 rewrite failed: ' || SQLCODE || ' ' || SQLERRM);
END;
/

PROMPT ===== A2 rewritten =====
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
      IF r.monthly_salary IS NULL OR r.monthly_salary <= 0 THEN
        DBMS_OUTPUT.PUT_LINE('Emp ' || r.emp_id || ' ' || r.first_name || ' ' || r.last_name ||
                             ' -> SKIPPED (invalid salary)');
        CONTINUE;  
      END IF;

      IF r.monthly_salary < 2000 THEN
        v_pct := 10;  v_msg := 'Priority review';
      ELSIF r.monthly_salary < 5000 THEN
        v_pct := 5;   v_msg := 'Standard review';
      ELSE
        v_pct := 0;   v_msg := 'No adjustment';
      END IF;

      v_new := r.monthly_salary * (1 + v_pct / 100);
      DBMS_OUTPUT.PUT_LINE('Emp ' || r.emp_id || ' ' || RPAD(r.first_name || ' ' || r.last_name, 18) ||
                           ' current=' || TO_CHAR(r.monthly_salary, 'FM99,990.00') ||
                           ' raise=' || v_pct || '%' ||
                           ' new=' || TO_CHAR(v_new, 'FM99,990.00') ||
                           ' (' || v_msg || ')');
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
    DBMS_OUTPUT.PUT_LINE('A2 rewrite: no employees found - run 00_setup/create_tables.sql first');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('A2 rewrite failed: ' || SQLCODE || ' ' || SQLERRM);
END;
/
