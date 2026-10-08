# Reflection (C2)

> DRAFT - rewrite in your own words and add your own experience before submitting.

## What I learned about GOTO

`GOTO` transfers control to a label written as `<<label_name>>`. In PL/SQL it
can jump forward or backward within the same block, or out to an enclosing
block, but it can never jump into an `IF`, `LOOP`, `CASE` or nested block, and
it cannot jump out of an exception handler back into its own block. In A3 I
triggered `PLS-00375` by trying exactly that, then fixed it by moving the
label to the same level as the `GOTO`. A label must also be followed by an
executable statement, which is why I used `NULL;` at the end of the loop in A2.

## GOTO versus structured code

After rewriting A1 and A2 in A4, the structured versions were shorter and
easier to follow: `CASE` and `ELSIF` show the decision in one place, and
`CONTINUE` replaces the "skip" label. With `GOTO`, I had to trace labels
around the code to know what ran next. I would avoid `GOTO` in normal code.
It is most defensible for a single jump to a common error or exit point, which
is how I used it in `fn_validate_payroll`.

## What I learned about functions

A function must return a value on every path. Using `%TYPE` keeps parameters
and variables in sync with the table columns. I used `RAISE_APPLICATION_ERROR`
with codes in the -20000 to -20999 range to report bad input clearly, and I
handled `NO_DATA_FOUND` explicitly. `fn_dept_name` returns a default value,
while `fn_annual_salary` raises an error. I chose between them based on whether
a missing row is a normal case or a real problem.

## Functions in SQL

In B5, my functions could be used in `SELECT` and `WHERE` because they only
read data. A function called from SQL cannot do DML or `COMMIT`. I also learned
that one raised exception stops the whole query, so I made `fn_validate_payroll`
catch every error and return text instead. It runs safely over every row.

## Challenges

- Remembering `SET SERVEROUTPUT ON` and the `/` that ends each block.
- Reading compile errors with `SHOW ERRORS`.
- Deciding how a function should behave on bad input (error versus default value).
- Using the correct service name (`FREEPDB1`) when connecting to Oracle Free in Docker.

## Git and documentation

I organised the repo by task type, wrote a README with run order and
assumptions, and kept screenshots as evidence of each output.
