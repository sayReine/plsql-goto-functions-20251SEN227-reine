
SET SERVEROUTPUT ON

PROMPT ===== ILLEGAL 1: GOTO into an IF block =====
DECLARE
  v_n NUMBER := 5;
BEGIN
  GOTO print_positive;          
  IF v_n > 0 THEN
    <<print_positive>>
    DBMS_OUTPUT.PUT_LINE('positive');
  END IF;
EXCEPTION
  WHEN OTHERS THEN              
    DBMS_OUTPUT.PUT_LINE('handler: ' || SQLERRM);
END;
/

PROMPT ===== ILLEGAL 2: GOTO into a nested block =====
BEGIN
  GOTO inner_label;             
    <<inner_label>>
    DBMS_OUTPUT.PUT_LINE('inside nested block');
  END;
EXCEPTION
  WHEN OTHERS THEN              
    DBMS_OUTPUT.PUT_LINE('handler: ' || SQLERRM);
END;
/

PROMPT ===== FIX 1: label moved to the same block level as the GOTO =====
DECLARE
  v_n NUMBER := 5;
BEGIN
  IF v_n > 0 THEN
    GOTO print_positive;       
  END IF;
  GOTO finish;

  <<print_positive>>
  DBMS_OUTPUT.PUT_LINE('positive');

  <<finish>>
  NULL;
EXCEPTION
  WHEN OTHERS THEN              
    DBMS_OUTPUT.PUT_LINE('Fix 1 failed: ' || SQLCODE || ' ' || SQLERRM);
END;
/

PROMPT ===== FIX 2: nested block removed; label at the same level =====
BEGIN
  GOTO inner_label;             
  DBMS_OUTPUT.PUT_LINE('this line is skipped');

  <<inner_label>>
  DBMS_OUTPUT.PUT_LINE('reached the label legally');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Fix 2 failed: ' || SQLCODE || ' ' || SQLERRM);
END;
/

PROMPT ===== PROOF: a handler catches RUNTIME errors but not compile errors =====
DECLARE
  v_n NUMBER;
BEGIN
  v_n := 10 / 0;                
  GOTO done;
  <<done>>
  NULL;
EXCEPTION
  WHEN ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE('Caught ZERO_DIVIDE at run time: ' || SQLERRM);
END;
/
