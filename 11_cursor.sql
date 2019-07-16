---Неявные курсоры---
--task 1
declare
faculty_rec FACULTY%rowtype;
begin
select * into faculty_rec from FACULTY where FACULTY = 'ТОВ';
dbms_output.put_line(faculty_rec.FACULTY_NAME || ' ' || faculty_rec.FACULTY);
end;

--task 2
declare
faculty_rec FACULTY%rowtype;
begin
select * into faculty_rec from FACULTY; --ERROR (не точная выборка)
dbms_output.put_line(faculty_rec.FACULTY_NAME || ' ' || faculty_rec.FACULTY);
exception
when others
then dbms_output.put_line(sqlerrm);
end;

--task 3
declare 
faculty_rec FACULTY%rowtype;
begin
select *   into faculty_rec from FACULTY;
dbms_output.put_line(faculty_rec.FACULTY||' '||faculty_rec.FACULTY_NAME);
exception
when too_many_rows then
dbms_output.put_line(sqlcode ||':' || ' Точная выборка возвращает количество строк больше запрошенного');
end;

--task 4
declare 
faculty_rec FACULTY%rowtype;
begin
select * into faculty_rec from FACULTY where FACULTY = 'КСиС';
dbms_output.put_line(faculty_rec.FACULTY||' '||faculty_rec.FACULTY_NAME);
exception
when no_data_found
then dbms_output.put_line(sqlerrm);
end;

--task 5
declare
b1 boolean;
b2 boolean;
b3 boolean;
n pls_integer;
begin
update AUDITORIUM set auditorium = '314-1', 
                   auditorium_name = '314-1',
                   auditorium_capacity = 110,
                   auditorium_type = 'ЛК'
where auditorium = '301-1';
--rollback;
b1 := sql%found;
b2 := sql%isopen;
b3 := sql%notfound;
n := sql%rowcount;
if b1 then dbms_output.put_line('found b1=TRUE');
else dbms_output.put_line('found b1=FALSE');
end if;
if b2 then dbms_output.put_line('isopen b2=TRUE');
else dbms_output.put_line('isopen b2=FALSE');
end if;
if b3 then dbms_output.put_line('notfound b3=TRUE');
else dbms_output.put_line('notfound b3=FALSE');
end if;
dbms_output.put_line('rowcount n='||n);
--rollback; --(второй rollback чтобы чекнуть изменения атрибутов курсора)
commit;
exception
when others
then dbms_output.put_line(sqlerrm);
end;

--select * from AUDITORIUM;

--task 6
declare
b1 boolean;
b2 boolean;
b3 boolean;
n pls_integer;
begin
update AUDITORIUM set auditorium = '206-1' --есть в БД
where auditorium = '324-1'; --есть в БД
--rollback;
b1 := sql%found;
b2 := sql%isopen;
b3 := sql%notfound;
n := sql%rowcount;
if b1 then dbms_output.put_line('found b1=TRUE');
else dbms_output.put_line('found b1=FALSE');
end if;
if b2 then dbms_output.put_line('isopen b2=TRUE');
else dbms_output.put_line('isopen b2=FALSE');
end if;
if b3 then dbms_output.put_line('notfound b3=TRUE');
else dbms_output.put_line('notfound b3=FALSE');
end if;
dbms_output.put_line('rowcount n='||n);
rollback;
exception
when others
then dbms_output.put_line(sqlerrm);
end;

--task 7
declare
n pls_integer;
auditorium_rec AUDITORIUM%rowtype;
begin
insert into AUDITORIUM (auditorium, auditorium_name,
auditorium_capacity, auditorium_type) values 
('310a-1', 
'310a-1', 15, 'ЛБ-К');
n := sql%rowcount;
select * into auditorium_rec from auditorium where auditorium = '310a-1';
dbms_output.put_line(auditorium_rec.AUDITORIUM ||' вместимость '|| auditorium_rec.auditorium_capacity);
dbms_output.put_line('rowcount n='||n);
commit;
exception
when others
then dbms_output.put_line(sqlerrm);
end;

--task 8
declare
n pls_integer;
begin
insert into AUDITORIUM (auditorium, auditorium_name,
auditorium_capacity, auditorium_type) values 
('206-1', -- ERROR (primary key)
'206-1', 15, 'ЛБ-К');
n := sql%rowcount;
dbms_output.put_line('rowcount n='||n);
rollback;
exception
when others
then dbms_output.put_line(sqlerrm);
end;

--task 9
declare
n pls_integer;
a_name AUDITORIUM.AUDITORIUM%type;
a_capacity AUDITORIUM.AUDITORIUM_CAPACITY%type;
a_type AUDITORIUM.AUDITORIUM_TYPE%type;
begin
delete from AUDITORIUM where AUDITORIUM = '310a-1'
returning AUDITORIUM, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE
into a_name, a_capacity, a_type;
n := sql%rowcount;
dbms_output.put_line('n = ' || n);
dbms_output.put_line(a_name || ' ' || a_capacity || ' ' || a_type);
commit;
--rollback;
exception
when others
then dbms_output.put_line(sqlerrm);
end;

--task 10
declare
n pls_integer;
begin
delete from FACULTY where FACULTY = 'ИДиП'; --ERROR
n := sql%rowcount;
dbms_output.put_line('n = ' || n);
--commit;
rollback;
exception
when others
then dbms_output.put_line(sqlerrm);
end;

---Явные курсоры---
--task 11
--select * from TEACHER;
declare
  teacher_info TEACHER.TEACHER%type;
  teacher_name_info TEACHER.TEACHER_NAME%type;
  pulpit_info TEACHER.PULPIT%type;
  cursor select_teacher is select * from TEACHER;
begin
  open select_teacher;
  dbms_output.put_line('Выбрано ' || select_teacher%rowcount);
  loop
  fetch select_teacher into teacher_info, teacher_name_info, pulpit_info;
  exit when select_teacher%notfound;
  dbms_output.put_line(teacher_info || ' ' || teacher_name_info || '  ' || pulpit_info);
  end loop;
  dbms_output.put_line('Выбрано ' || select_teacher%rowcount);
  close select_teacher;
exception
  when others
  then dbms_output.put_line(sqlerrm);
end;

--task 12
declare 
  cursor curs_subject is select * from SUBJECT;
  rec_subject SUBJECT%rowtype;
begin
open curs_subject;
  dbms_output.put_line('rowcount = '|| curs_subject%rowcount);
  fetch curs_subject into rec_subject;
  while curs_subject%found
  loop
  dbms_output.put_line(' ' || curs_subject%rowcount ||' '|| rec_subject.SUBJECT||' '|| rec_subject.SUBJECT_NAME ||' '|| rec_subject.PULPIT);
  fetch curs_subject into rec_subject;
  end loop;
  dbms_output.put_line('rowcount = '||curs_subject%rowcount);
close curs_subject;
exception
  when others
  then dbms_output.put_line(sqlerrm);
end;

--task 13
declare
cursor pulpit_teacher is select t.TEACHER_NAME, p.PULPIT_NAME from
TEACHER t inner join PULPIT p on t.PULPIT = p.PULPIT;
begin
  for res in pulpit_teacher
  loop
  dbms_output.put_line('PULPIT: '|| res.PULPIT_NAME ||' TEACHER: ' || res.TEACHER_NAME);
  end loop;
end;

--task 14
declare 
cursor cur_auditorium(par1 AUDITORIUM.AUDITORIUM_CAPACITY%type, par2 AUDITORIUM.AUDITORIUM_CAPACITY%type)
  is select AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_CAPACITY, AUDITORIUM_TYPE from AUDITORIUM 
  where AUDITORIUM_CAPACITY >= par1 AND AUDITORIUM_CAPACITY <= par2;
rec_auditorium AUDITORIUM%rowtype;
begin
  dbms_output.put_line('CAPACITY <= 20');
open cur_auditorium(0,20);
loop
fetch cur_auditorium into rec_auditorium;
exit when cur_auditorium%notfound;
  dbms_output.put_line(' '|| cur_auditorium%rowcount ||' '|| rec_auditorium.auditorium ||' '||
  rec_auditorium.auditorium_name||' '||rec_auditorium.auditorium_capacity||' '||rec_auditorium.auditorium_type);
end loop;
close cur_auditorium;

dbms_output.put_line('21 <= CAPACITY <= 30');
open cur_auditorium(21,30);
  fetch cur_auditorium into rec_auditorium;
while cur_auditorium%found
loop
  dbms_output.put_line(' '||cur_auditorium%rowcount||' '||rec_auditorium.auditorium||' '||
  rec_auditorium.auditorium_name||' '||rec_auditorium.auditorium_capacity||' '||rec_auditorium.auditorium_type);
  fetch cur_auditorium into rec_auditorium;
end loop;
close cur_auditorium;

dbms_output.put_line('31 <= CAPACITY <= 60');
for rec in cur_auditorium(31,60)
loop
  dbms_output.put_line(' '||rec.auditorium||' '||rec.auditorium_name||' '
  ||rec.auditorium_capacity||' '||rec.auditorium_type);
end loop;

dbms_output.put_line('61 <= CAPACITY <= 80');
for rec in cur_auditorium(61,80)
loop
  dbms_output.put_line(' '||rec.auditorium||' '||rec.auditorium_name||' '
  ||rec.auditorium_capacity||' '||rec.auditorium_type);
end loop;

dbms_output.put_line('81 <= CAPACITY <= 100');
for rec in cur_auditorium(81,100)
loop
  dbms_output.put_line(' '||rec.auditorium||' '||rec.auditorium_name||' '
  ||rec.auditorium_capacity||' '||rec.auditorium_type);
end loop;
exception
  when others
  then dbms_output.put_line(sqlerrm);
end;

--task 15 --TODO
variable x refcursor;
declare
type per is ref cursor  return AUDITORIUM_TYPE%rowtype;
xcur  per; 
begin 
open xcur for select * from AUDITORIUM_TYPE;
:x := xcur;
exception
when others
then dbms_output.put_line(sqlerrm);
end;

print x;

--task 16
declare 
cursor curs_aut is select auditorium_type,
cursor (
  select auditorium
  from auditorium aum
  where aut.auditorium_type = aum.auditorium_type
)
from auditorium_type aut;
curs_aum sys_refcursor;
aut auditorium_type.auditorium_type%type;
txt varchar2(1000);
aum auditorium.auditorium%type;
begin
open curs_aut;
fetch curs_aut into aut, curs_aum;
while (curs_aut%found)
loop
txt:= rtrim(aut)||':';
  loop
    fetch curs_aum into aum;
    exit when curs_aum%notfound;
    txt:=txt||','||rtrim(aum);
  end loop;
  dbms_output.put_line(txt);
  fetch curs_aut into aut, curs_aum;
end loop;
close curs_aut;
exception
  when others
  then dbms_output.put_line(sqlerrm);
end;

--task 17
declare 
cursor curs_auditorium is select * from  AUDITORIUM  for update;
begin 
for res in curs_auditorium
loop
if res.AUDITORIUM_CAPACITY >=40 AND  res.AUDITORIUM_CAPACITY <= 80
then 
update AUDITORIUM set AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY * 0.9 where current of curs_auditorium;
end if;
dbms_output.put_line(''||res.auditorium||' '||res.auditorium_capacity);
end loop;
rollback;
exception
  when others
  then dbms_output.put_line(sqlerrm);
end;

--task 18
declare 
cursor curs_auditorium is select * from  auditorium  for update;
begin 
for res in curs_auditorium
loop
if res.auditorium_capacity >=0 AND  res.auditorium_capacity <= 20
then 
delete auditorium  where current of curs_auditorium;
end if;
dbms_output.put_line(''||res.auditorium||' '||res.auditorium_capacity);
end loop;
--rollback;
exception
  when others
  then dbms_output.put_line(sqlerrm);
end;

--task 19
declare 
cursor cur_auditorium is select auditorium, auditorium_capacity, rowid from  auditorium  for update;
begin 
for res in cur_auditorium
loop
if res.auditorium_capacity > 90 
then 
  delete auditorium  where rowid = res.rowid;
end if;
if res.auditorium_capacity = 90 
then 
  update auditorium set auditorium_capacity = auditorium_capacity + 5 
  where rowid=res.rowid;
end if;
dbms_output.put_line(''||res.auditorium||' '||res.auditorium_capacity||' '||res.rowid);
end loop;
--rollback;
exception
  when others
  then dbms_output.put_line(sqlerrm);
end;

--task 20
declare 
cursor curs_t is select * from teacher;
rec_teacher teacher%rowtype;
begin
open curs_t;
  fetch curs_t into rec_teacher;
while curs_t%found
loop
  dbms_output.put_line(' '||rec_teacher.teacher_name);
  if curs_t%rowcount MOD 3=0
  then 
    dbms_output.put_line('----------------------------------------------------');
  end if;
  fetch curs_t into rec_teacher;
end loop;
close curs_t;
exception
  when others
  then dbms_output.put_line(sqlerrm);
end;

