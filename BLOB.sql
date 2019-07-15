create tablespace first_blob
datafile 'C:\Lab08BLOB\first_blob.dbf'
size 50m autoextend on next 1m;

create user C##Maxon identified by Aa71600166
grant all privileges to C##Maxon;

--alter user C##Maxon container=all;
select * from v$tablespace

alter user C##Maxon default tablespace first_blob quota unlimited on first_blob
account unlock container=current;

--create directory Bfile_dir as 'C:/Bfile';
--create directory BigF as 'C:/BigF';
create directory BLOBS as 'C:\BLOBS';
grant read, write on directory BLOBS to C##Maxon;


create table BigFiles(
id number(5) primary key,
FOTO BLOB,
DOC_or_PDF BFILE);

insert into BigFiles values(1, null, BFILENAME('BLOBS', 'sert.JPG'));
insert into BigFiles values(2, null, BFILENAME('BLOBS', 'Otchet18.docx'));

select * from BigFiles;
delete BigFiles;


declare 
v_blob BLOB;
v_file BFILE;
v_file_size binary_integer;
 begin 
  v_file := BFILENAME('BLOBS', 'sert.JPG');
 insert into BigFiles(id, FOTO, DOC_or_PDF) values (3, EMPTY_BLOB(), null) RETURNING FOTO INTO v_blob;
 DBMS_LOB.FILEOPEN(v_file, DBMS_LOB.FILE_READONLY);
 v_file_size := DBMS_LOB.GETLENGTH(v_file);
DBMS_LOB.LOADFROMFILE(v_blob, v_file, v_file_size);
DBMS_LOB.FILECLOSE(v_file);
commit;
end;

select * from BigFiles

