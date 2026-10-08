# PL/SQL GOTO Statements and Functions

Individual Assignment III. Covers PL/SQL `GOTO`, stored functions, exception
handling, functions used inside SQL, and Git/GitHub documentation.

**Student:** _SAYINZOGA Reine Esther KEZA_  |  **ID:** _20251SEN227_  |  **Database:** Oracle Database Free (Docker `gvenzl/oracle-free`)

## Repository structure

```
00_setup/      create_tables.sql              tables + sample data
01_goto/       A1-A4                          GOTO programs, illegal GOTO, rewrite
02_functions/  B1-B4, C1                      stored functions
03_tests/      B5, test_functions, test_validate_payroll
screenshots/   output screenshots
docs/          REFLECTION.md
```

## How to run

1. Start the database and connect (service `FREEPDB1`):
   ```bash
   docker exec -it oracle-free sqlplus student/StudentPass123@//localhost:1521/FREEPDB1
   ```
2. Run the scripts in this order (repo mounted at `/work`):
   ```sql
   SET SERVEROUTPUT ON
   @/work/00_setup/create_tables.sql
   @/work/02_functions/B1_fn_annual_salary.sql
   @/work/02_functions/B2_fn_years_of_service.sql
   @/work/02_functions/B3_fn_calculate_tax.sql
   @/work/02_functions/B4_fn_dept_name.sql
   @/work/02_functions/C1_fn_validate_payroll.sql
   @/work/01_goto/A1_number_classifier.sql
   @/work/01_goto/A2_salary_review.sql
   @/work/01_goto/A3_illegal_goto.sql
   @/work/01_goto/A4_rewrite_no_goto.sql
   @/work/03_tests/test_functions.sql
   @/work/03_tests/test_validate_payroll.sql
   @/work/03_tests/B5_functions_in_select.sql
   ```
3. Capture the screenshots listed below into `screenshots/`.

## Task summary

| Task | File | What it does |
|---|---|---|
| A1 | `01_goto/A1_number_classifier.sql` | Positive/negative/zero and even/odd using `GOTO` |
| A2 | `01_goto/A2_salary_review.sql` | Raise recommendations; bad rows skipped with `GOTO` |
| A3 | `01_goto/A3_illegal_goto.sql` | Two illegal `GOTO`s (PLS-00375) and their fixes |
| A4 | `01_goto/A4_rewrite_no_goto.sql` | A1 and A2 rewritten with `CASE`/`IF`/`CONTINUE` |
| B1 | `02_functions/B1_fn_annual_salary.sql` | Monthly salary x 12 |
| B2 | `02_functions/B2_fn_years_of_service.sql` | Complete years since hire date |
| B3 | `02_functions/B3_fn_calculate_tax.sql` | Progressive tax brackets |
| B4 | `02_functions/B4_fn_dept_name.sql` | Department name or `Unknown Department` |
| B5 | `03_tests/B5_functions_in_select.sql` | Functions called from `SELECT` and `WHERE` |
| C1 | `02_functions/C1_fn_validate_payroll.sql` | Returns `VALID` / `INVALID: reason` |
| C2 | `docs/REFLECTION.md` | Written reflection |

## Assumptions

- Tax brackets (B3): 0% up to 12,000; 10% to 48,000; 20% to 120,000; 30% above.
- Raise rules (A2): salary < 2000 gets 10%, < 5000 gets 5%, otherwise 0%.
- Employees 6-9 contain deliberately bad data to exercise the validator, so
  `employees` has no CHECK or FOREIGN KEY constraints.
- Custom error codes: B1 `-20001..-20003`, B2 `-20011..-20013`, B3 `-20021`.

## Screenshots

| File | Shows |
|---|---|
| `A1_output.png` | A1 output |
| `A2_output.png` | A2 output |
| `A3_error_and_fix.png` | PLS-00375 errors plus the fixed blocks |
| `A4_output.png` | A4 output |
| `B5_select_output.png` | B5 queries |
| `C1_output.png` | `test_validate_payroll.sql` output |

## Exception handling summary

| Unit | Handled | Approach |
|---|---|---|
| A1, A4 (part 1) | NULL element, any per-element error, collection index errors | user-defined `e_null_number` in an inner block, outer `WHEN OTHERS` |
| A2, A4 (part 2) | bad salary, `VALUE_ERROR`, empty table | inner block per row, user-defined `e_no_employees` |
| A3 | runtime vs compile errors | `PLS-00375` is a compile-time error, so the handler in the illegal blocks never runs; `ZERO_DIVIDE` proof block shows a runtime handler working |
| B1 | `NO_DATA_FOUND`, `TOO_MANY_ROWS`, `OTHERS` | `RAISE_APPLICATION_ERROR` -20003/-20004/-20009; own -2000x errors re-raised unchanged |
| B2 | same as B1 | -20013/-20014/-20019 |
| B3 | `VALUE_ERROR`, `OTHERS` | -20022/-20029; -20021 re-raised unchanged |
| B4 | `NO_DATA_FOUND`, `TOO_MANY_ROWS`, `OTHERS` | returns text, never raises (safe in SQL) |
| C1 | `NO_DATA_FOUND`, `OTHERS` | returns `INVALID: ...`, never raises |
| Tests | any failure | outer handler prints a hint instead of a raw stack trace |
| `create_tables.sql` | drop of missing table | ignores `ORA-00942`, re-raises everything else |
