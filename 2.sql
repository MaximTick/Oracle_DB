create tablespace oracle_week
datafile 'C:\MaxTick\oracle_week.dbf'
size 10m autoextend on next 500k
maxsize 60m
extent management local; --

create temporary tablespace oracle_week_temp
tempfile 'C:\MaxTick\oracle_week_temp.dbf'
size 5m autoextend on next 3M
maxsize 30m
extent management local;

--drop tablespace oracle_week;

select tablespace_name, status, contents logging from sys.dba_tablespaces;

SELECT * FROM SYS.DBA_DATA_FILES;
SELECT * FROM SYS.DBA_TEMP_FILES;

--TASK 4
create role C##RL_ORACLE_WEEK;

GRANT create session,
      create table,
      create procedure,
      create view
TO   C##RL_ORACLE_WEEK;

select * from dba_roles where role = 'C##RL_ORACLE_WEEK';
select * from dba_sys_privs where GRANTEE = 'C##RL_ORACLE_WEEK';

--TASK 5
CREATE PROFILE C##PF_ORACLE_WEEK LIMIT
PASSWORD_LIFE_TIME 30
SESSIONS_PER_USER 4
FAILED_LOGIN_ATTEMPTS 5
PASSWORD_LOCK_TIME 1
PASSWORD_REUSE_TIME 365
PASSWORD_GRACE_TIME DEFAULT
CONNECT_TIME 360
IDLE_TIME 20

SELECT * FROM DBA_PROFILES WHERE PROFILE = 'C##PF_ORACLE_WEEK'

ALTER SESSION SET CONTAINER = PDB_ORACLE_WEEK;

create USER C##US_ORACLE_MAX IDENTIFIED BY qwert12345  --step1
DEFAULT TABLESPACE ORACLE_WEEK QUOTA UNLIMITED ON ORACLE_WEEK
TEMPORARY TABLESPACE ORACLE_WEEK_TEMP
PROFILE C##PF_ORACLE_WEEK
ACCOUNT UNLOCK
PASSWORD EXPIREWE

GRANT C##RL_ORACLE_WEEK TO C##US_ORACLE_WEEK;

--если возникла ошибка ORA-65048 - проверяем наличие табличного пространстав в PDB
--если пусто - создаем PDB или даеи GRANT на сущестувующую PDB
select cp.pdb_name from cdb_pdbs cp join v$tablespace tb on (cp.con_id = tb.con_id)
where tb.name = 'ORACLE_WEEK';

--после выдачи роли коннектимся первый раз через sqlplus
--меняем там password и опять коннектимя. У нас должно получиться т.к. мы выдали роль
--юзеру в которой есть GRANT на CREATE SSESION


--ДЛЯ УСПЕШНОГО ПОДКЛЮЧЕНИЯ К PDB НУЖНО СПЕРВА ЗАЙТИ ПОД ЮЕРОМ, 
--КОТОРЫЙ ЯВЛЯЕТСЯ АДМИНОМ PDB (УКАЗЫВАЛИ ПРИ СОЗДАНИИ PDB)с ролью SYSDBA
--соединяемся через sqlplus (sql dveloper не прокатил)
connect US_ORALCE_WEEK/qwert12345@//localhost:1521/pdb_oracle_week.be.by as sysdba;
--успешно подключившись даем грант нашему юзеру на сессию в данной PDB(sqlplus)
grant create session to C## US_ORALCE_WEEK
--ПРОБУЕМ ПОДКЛЮЧИТЬСЯ К РАНЕЕ СОЗДАННОЙ PDB
--QWERTY1 ЭТО ИЗМЕННЕНЫЙ ПАРОЛЬ ДЛЯ НАШЕГО ЮЗЕРА
connect C##US_ORALCE_WEEK/QWERTY1@//localhost:1521/PDB_ORACLE_WEEK.be.by;
--если какие-то траблы подрубаемся под ролью sysdba
--connect /as sysdba (sqlplus)
--смотрим наши pdb: show pdbs если restricted - yes, то
--останавливаем и запускаем экземпляр с помощью комнд
-- shutdown immediate
-- startup
--show pdbs (по-идее в RESTRICTED НАШЕЙ PDB ДОЛЖНО БЫТЬ ПУСТО)

