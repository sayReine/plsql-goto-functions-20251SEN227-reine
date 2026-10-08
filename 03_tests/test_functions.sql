-- =====================================================================
-- test_functions.sql - self-checking tests for B1-B4
-- Every line prints PASS or FAIL.
-- =====================================================================
SET SERVEROUTPUT ON

DECLARE
  v_n NUMBER;
  v_s VARCHAR2(100);

  PROCEDURE check_num(p_label VARCHAR2, p_expected NUMBER, p_actual NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD(p_label, 42) || ' expected=' || RPAD(p_expected, 8) ||
                         ' actual=' || RPAD(p_actual, 8) ||
                         CASE WHEN p_expected = p_actual THEN ' PASS' ELSE ' FAIL' END);
  END;

  PROCEDURE check_str(p_label VARCHAR2, p_expected VARCHAR2, p_actual VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD(p_label, 42) || ' expected=' || p_expected || ' actual=' || p_actual ||
                         CASE WHEN p_expected = p_actual THEN ' PASS' ELSE ' FAIL' END);
  END;

  PROCEDURE check_err(p_label VARCHAR2, p_expected_code NUMBER, p_actual_code NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD(p_label, 42) || ' expected=ORA' || p_expected_code ||
                         ' actual=ORA' || p_actual_code ||
                         CASE WHEN p_expected_code = p_actual_code THEN ' PASS' ELSE ' FAIL' END);
  END;
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- B1 fn_annual_salary ---');
  check_num('Emp 1 annual salary', 54000, fn_annual_salary(1));
  check_num('Emp 2 annual salary', 33600, fn_annual_salary(2));
  BEGIN v_n := fn_annual_salary(999);
    DBMS_OUTPUT.PUT_LINE('Emp 999 (not found)  FAIL - no error raised');
  EXCEPTION WHEN OTHERS THEN check_err('Emp 999 not found', -20003, SQLCODE); END;
  BEGIN v_n := fn_annual_salary(6);
    DBMS_OUTPUT.PUT_LINE('Emp 6 (negative)  FAIL - no error raised');
  EXCEPTION WHEN OTHERS THEN check_err('Emp 6 negative salary', -20002, SQLCODE); END;
  BEGIN v_n := fn_annual_salary(NULL);
    DBMS_OUTPUT.PUT_LINE('NULL id  FAIL - no error raised');
  EXCEPTION WHEN OTHERS THEN check_err('NULL employee id', -20001, SQLCODE); END;

  DBMS_OUTPUT.PUT_LINE('--- B2 fn_years_of_service ---');
  v_n := fn_years_of_service(1);
  DBMS_OUTPUT.PUT_LINE(RPAD('Emp 1 (hired 2018-03-15) years', 42) || ' actual=' || v_n ||
                       CASE WHEN v_n >= 8 THEN ' PASS' ELSE ' FAIL' END);
  BEGIN v_n := fn_years_of_service(8);
    DBMS_OUTPUT.PUT_LINE('Emp 8 (future date)  FAIL - no error raised');
  EXCEPTION WHEN OTHERS THEN check_err('Emp 8 future hire date', -20012, SQLCODE); END;
  BEGIN v_n := fn_years_of_service(999);
    DBMS_OUTPUT.PUT_LINE('Emp 999  FAIL - no error raised');
  EXCEPTION WHEN OTHERS THEN check_err('Emp 999 not found', -20013, SQLCODE); END;

  DBMS_OUTPUT.PUT_LINE('--- B3 fn_calculate_tax ---');
  check_num('Tax on 0',       0,     fn_calculate_tax(0));
  check_num('Tax on 12,000',  0,     fn_calculate_tax(12000));
  check_num('Tax on 33,600',  2160,  fn_calculate_tax(33600));
  check_num('Tax on 54,000',  4800,  fn_calculate_tax(54000));
  check_num('Tax on 120,000', 18000, fn_calculate_tax(120000));
  check_num('Tax on 200,000', 42000, fn_calculate_tax(200000));
  BEGIN v_n := fn_calculate_tax(-1);
    DBMS_OUTPUT.PUT_LINE('Tax on -1  FAIL - no error raised');
  EXCEPTION WHEN OTHERS THEN check_err('Tax on negative salary', -20021, SQLCODE); END;
  BEGIN v_n := fn_calculate_tax(NULL);
    DBMS_OUTPUT.PUT_LINE('Tax on NULL  FAIL - no error raised');
  EXCEPTION WHEN OTHERS THEN check_err('Tax on NULL', -20021, SQLCODE); END;

  DBMS_OUTPUT.PUT_LINE('--- B4 fn_dept_name ---');
  check_str('Dept 10',       'Finance',            fn_dept_name(10));
  check_str('Dept 30',       'IT',                 fn_dept_name(30));
  check_str('Dept 99',       'Unknown Department', fn_dept_name(99));
  check_str('Dept NULL',     'Unknown Department', fn_dept_name(NULL));
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('TEST SCRIPT ABORTED: ' || SQLCODE || ' ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('Did you run create_tables.sql and the 02_functions scripts first?');
END;
/
