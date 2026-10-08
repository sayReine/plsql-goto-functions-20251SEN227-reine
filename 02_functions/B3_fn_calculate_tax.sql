
CREATE OR REPLACE FUNCTION fn_calculate_tax (
  p_annual_salary IN NUMBER
) RETURN NUMBER
IS
  v_tax NUMBER;
BEGIN
  IF p_annual_salary IS NULL OR p_annual_salary < 0 THEN
    RAISE_APPLICATION_ERROR(-20021, 'Annual salary must be a non-negative number');
  END IF;

  IF p_annual_salary <= 12000 THEN
    v_tax := 0;
  ELSIF p_annual_salary <= 48000 THEN
    v_tax := (p_annual_salary - 12000) * 0.10;
  ELSIF p_annual_salary <= 120000 THEN
    v_tax := 3600 + (p_annual_salary - 48000) * 0.20;
  ELSE
    v_tax := 18000 + (p_annual_salary - 120000) * 0.30;
  END IF;

  RETURN ROUND(v_tax, 2);
EXCEPTION
  WHEN VALUE_ERROR THEN
    RAISE_APPLICATION_ERROR(-20022, 'Numeric or value error while calculating tax');
  WHEN OTHERS THEN
    IF SQLCODE BETWEEN -20999 AND -20000 THEN
      RAISE;                   
    ELSE
      RAISE_APPLICATION_ERROR(-20029, 'Unexpected error in fn_calculate_tax: ' || SQLERRM);
    END IF;
END fn_calculate_tax;
/
SHOW ERRORS
