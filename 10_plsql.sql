--Изначально нужно выполнить скрипт предоставленный Блиновой 
--для создания и заполнения таблииц БД "Универ"
--task 1
begin 
null;
end;

--task 2
begin
DBMS_OUTPUT.PUT_LINE('Hello World');
end;

--task 3
declare 
  x number(3) := 10;
  y number(3) := 0;
  z number(3);
begin
  z := x/y;
  dbms_output.put_line('z=' || z);
exception
  when others
  then dbms_output.put_line('ERROR sqlcode--> ' || sqlcode || ' <--sqlcode  sqlerrm--> ' || sqlerrm);
end;

--task 4
declare 
  x number(3) := 10;
  y number(3) := 0;
  z number(3);
begin
  dbms_output.put_line('x+y = ' || (x+y));
  begin
  z := x/y;
exception
  when others
  then dbms_output.put_line('ERROR: ' || sqlerrm);
end;
  dbms_output.put_line('z=' || z);
end;

--task 5
show parameter plsql_warnings;
select name, value from v$parameter where name = 'plsql_warnings'

alter system set plsql_warnings = 'ENABLE:INFORMATIONAL'
SELECT DBMS_WARNING.GET_WARNING_SETTING_STRING FROM DUAL

--task 6
select keyword from v$reserved_words
where length = 1;

--task 7
select keyword, length, con_id from v$reserved_words
where length > 1 and keyword != 'A' order by keyword;

--task 8
show parameter
select * from v$parameter;

--task 9
begin
DBMS_OUTPUT.PUT_LINE('Hello World');
end;

--test 10
declare
n1 number(1) := 1;
n2 number := 678;
-- кроме number в pl/sql
n3 binary_integer := 123.645; --not in db (around 124)
n4 pls_integer := 123.656;    --not in db (around 124)
n5 natural := 45.67;          --not in db (around 46) [0.. 2^31-1]
n6 naturaln := 45.67;
n7 positive := 45.67;
n8 positiven := 45.67;
n9 signtype := 0.4;           -- -1 or 0 or 1 (0.4 around 0)
begin 
dbms_output.put_line('n1 = ' || n1);
dbms_output.put_line('n2 = ' || n2);
dbms_output.put_line('n3 = ' || n3);
dbms_output.put_line('n4 = ' || n4);
dbms_output.put_line('n5 = ' || n5);
dbms_output.put_line('n6 = ' || n6);
dbms_output.put_line('n7 = ' || n7);
dbms_output.put_line('n8 = ' || n8);
dbms_output.put_line('n9 = ' || n9);
end;

--task 11
declare
n1 number := 35;
n2 number := 190;
begin
dbms_output.put_line('n2/n1 = ' || (n2/n1));
end;

--task 12 && 13
declare
n number := 1234.5678;
n1 number(3,2) := 1.22;
n2 number(5,3) := 12.444;
n3 number(4, -2) := 160.65768; -- (around 200)
begin
dbms_output.put_line('n = ' || n);
dbms_output.put_line('n1 = ' || n1);
dbms_output.put_line('n2 = ' || n2);
dbms_output.put_line('n3 = ' || n3);
end;

-- task 14 && 15
declare 
n1 binary_float := 12345.6789;
n2 binary_double := 123456.789;
begin
dbms_output.put_line('n1 = ' || n1);
dbms_output.put_line('n2 = ' || n2);
end;

--task 16
declare
n1 number := 127E-2;
begin
dbms_output.put_line('n1 = ' || n1);
end;

--task 17
declare 
b1 boolean := true;
b2 boolean := false;
b3 boolean;
begin
if b1 then dbms_output.put_line('b1 = ' || 'true'); end if;
if b3 is null
  then dbms_output.put_line('b3 = ' || 'null'); end if;
end;

--task 18
declare
curr_year constant number := TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'));
author constant varchar2(10) := 'Max';
author_sur  char(4) := 'Maxi';
begin
curr_year := 2018; --ERROR (don't catch)
dbms_output.put_line(curr_year); 
dbms_output.put_line(author); 
dbms_output.put_line(author_sur); 
exception
  when others
  then dbms_output.put_line('error = ' || sqlerrm);
end;

--task 19
declare
pulp pulpit.pulpit%type;
begin 
pulp := 'ПОИТ';
dbms_output.put_line(pulp);
end;

--task 20
declare
faculty_res faculty%rowtype;
begin 
faculty_res.faculty := 'ФИТ';
faculty_res.faculty_name := 'Факультет информационных технологий';
dbms_output.put_line(faculty_res.faculty);
end;

--task 21 && 22
declare 
x pls_integer := 17;
begin
if 8 > x then
dbms_output.put_line('8 > '||x);
end if;
if 8 < x then
dbms_output.put_line('8 < '||x);
else
dbms_output.put_line('8 = '|| x);
end if;
end;

--task 23
declare 
x pls_integer := 17;
begin
case x
when 1 then
dbms_output.put_line('1');
else dbms_output.put_line('1 not 17');
end case;
case
when x between 13 and 20 then
dbms_output.put_line('13<='||x||'<=20');
end case;
end;

--task 24 && 35 && 26 (всё одим блоком)
declare 
x pls_integer := 0;
begin
loop
x:=x+1;
dbms_output.put_line(x);
exit when x > 5;
end loop;

for k in 1..5
loop
dbms_output.put_line(k);
end loop;

while ( x > 0)
loop
x := x-1;
dbms_output.put_line(x);
end loop;
end;