SET SERVEROUTPUT ON;
declare
    exception_test EXCEPTION;
begin  -- niveau 1
    begin  -- niveau 2
        begin  -- niveau 3
            raise exception_test;
            DBMS_OUTPUT.PUT_LINE('Je suis dans le bloc 3');
        Exception
            when exception_test then
                DBMS_OUTPUT.PUT_LINE('L''exception exception_test a été déclenchée');
        end;
        DBMS_OUTPUT.PUT_LINE('Je suis dans le bloc 2');
    end;
    DBMS_OUTPUT.PUT_LINE('Je suis dans le bloc 1');
end;
/


