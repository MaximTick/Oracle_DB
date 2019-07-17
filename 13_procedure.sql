--task 1
create or replace 
procedure GET_TEACHERS(PCODE in TEACHER.PULPIT%TYPE)
is
cursor teacher_in_pulpit is select TEACHER_NAME, PULPIT from TEACHER
                            where PULPIT = PCODE;
begin
for teach in teacher_in_pulpit
loop
dbms_output.put_line(teach.TEACHER_NAME || ' ' || teach.PULPIT);
end loop;
exception
  when no_data_found
  then dbms_output.put_line(sqlerrm);
end GET_TEACHERS;

execute GET_TEACHERS('ИСиТ');


declare
procedure GET_TEACHERS(PCODE in TEACHER.PULPIT%TYPE)
is
cursor teacher_in_pulpit is select TEACHER_NAME, PULPIT from TEACHER
                            where PULPIT = PCODE;
begin
for teach in teacher_in_pulpit
loop
dbms_output.put_line(teach.TEACHER_NAME || ' ' || teach.PULPIT);
end loop;
end GET_TEACHERS;
begin
GET_TEACHERS('ПОиСОИ');
exception
  when no_data_found
  then dbms_output.put_line(sqlerrm);
end;

--task 2
declare 
res number;
function GET_NUM_TEACHERS(PCODE TEACHER.PULPIT%TYPE)
  return number is
    count_teacher number;
begin
  SELECT COUNT(*) INTO count_teacher FROM TEACHER WHERE PULPIT = PCODE;
  return count_teacher;
  exception
    when others then
    return -1;
END GET_NUM_TEACHERS;
begin
 res:=GET_NUM_TEACHERS('ИСиТ');
 dbms_output.put_line(res);
end;

--task 3
create or replace procedure GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
is
cursor faculty_teacher is
select t.TEACHER_NAME, f.FACULTY from TEACHER t join PULPIT p
on p.PULPIT = t.PULPIT join FACULTY f on f.FACULTY = p.FACULTY where
f.FACULTY = FCODE;
begin
  for info in faculty_teacher
  loop
  dbms_output.put_line(info.TEACHER_NAME);
  end loop;
exception
  when others
  then dbms_output.put_line(sqlerrm);  
end GET_TEACHERS;

execute GET_TEACHERS('ИДиП');

--task 4
create or replace  procedure GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
is
cursor subject_pulpit is 
select SUBJECT, SUBJECT_NAME from SUBJECT where PULPIT = PCODE;
begin
  for info in subject_pulpit
  loop
    dbms_output.put_line(info.SUBJECT ||' ' || info.SUBJECT_NAME);
  end loop;
exception
  when others
  then dbms_output.put_line(sqlerrm);  
end GET_SUBJECTS;

begin
GET_SUBJECTS('ИСиТ');
end;

--task 5
declare
res number;
function GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
return number
is
count_teachers number;
begin
select count(*) into count_teachers from TEACHER t join PULPIT p
on p.PULPIT = t.PULPIT join FACULTY f on f.FACULTY = p.FACULTY where
f.FACULTY = FCODE;
return count_teachers;
exception
    when others then
    return -1;
end GET_NUM_TEACHERS;
begin
 res := GET_NUM_TEACHERS('ИДиП');
 dbms_output.put_line(res);
end;

--task 5
create or replace function GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) return number
is
count_subject number;
begin
  select count(*) into count_subject from SUBJECT where PULPIT = PCODE;
  return count_subject;
exception
  when others
  then dbms_output.put_line(sqlerrm);  
end GET_NUM_SUBJECTS;

select GET_NUM_SUBJECTS('ИСиТ') from DUAL;

begin
dbms_output.put_line(GET_NUM_SUBJECTS('ИСиТ'));
end;

--task 6
create or replace package TEACHERS
as
procedure GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE);
procedure GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE);
function GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER;
function GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER;
end TEACHERS;

create or replace package body TEACHERS
as
procedure GET_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
is
cursor faculty_teacher is
select t.TEACHER_NAME, f.FACULTY from TEACHER t join PULPIT p
on p.PULPIT = t.PULPIT join FACULTY f on f.FACULTY = p.FACULTY where
f.FACULTY = FCODE;
begin
  for info in faculty_teacher
  loop
  dbms_output.put_line(info.TEACHER_NAME);
  end loop;
exception
  when others
  then dbms_output.put_line(sqlerrm);  
end GET_TEACHERS;

procedure GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
is
cursor subject_pulpit is 
select SUBJECT, SUBJECT_NAME from SUBJECT where PULPIT = PCODE;
begin
  for info in subject_pulpit
  loop
    dbms_output.put_line(info.SUBJECT ||' ' || info.SUBJECT_NAME);
  end loop;
exception
  when others
  then dbms_output.put_line(sqlerrm);  
end GET_SUBJECTS;

function GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE)
return number
is
count_teachers number;
begin
select count(*) into count_teachers from TEACHER t join PULPIT p
on p.PULPIT = t.PULPIT join FACULTY f on f.FACULTY = p.FACULTY where
f.FACULTY = FCODE;
return count_teachers;
exception
    when others then
    return -1;
end GET_NUM_TEACHERS;

function GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) return number
is
count_subject number;
begin
  select count(*) into count_subject from SUBJECT where PULPIT = PCODE;
  return count_subject;
exception
  when others
  then dbms_output.put_line(sqlerrm);  
end GET_NUM_SUBJECTS;
end TEACHERS;

--task 7
execute TEACHERS.GET_SUBJECTS('ИСиТ');
execute TEACHERS.GET_TEACHERS('ТОВ');
select TEACHERS.GET_NUM_SUBJECTS('ИСиТ') from DUAL;
select TEACHERS.GET_NUM_TEACHERS('ИДиП') from DUAL;

declare
res number;
begin
 res := TEACHERS.GET_NUM_TEACHERS('ИДиП');
 dbms_output.put_line(res);
end;