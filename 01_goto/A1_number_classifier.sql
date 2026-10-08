SET SERVEROUTPUT ON

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

      
      IF v_num > 0 THEN
        GOTO positive_number;
      ELSIF v_num < 0 THEN
        GOTO negative_number;
      ELSE
        GOTO zero_number;
      END IF;

      <<positive_number>>
      v_sign := 'Positive';
      GOTO check_parity;

      <<negative_number>>
      v_sign := 'Negative';
      GOTO check_parity;

      <<zero_number>>
      v_sign := 'Zero';
    

      <<check_parity>>
      IF MOD(v_num, 2) = 0 THEN
        v_parity := 'Even';
      ELSE
        v_parity := 'Odd';
      END IF;

      <<print_result>>
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
    DBMS_OUTPUT.PUT_LINE('A1 failed: collection index out of range');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('A1 failed: ' || SQLCODE || ' ' || SQLERRM);
END;
/
