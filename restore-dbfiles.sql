create database les3piliersBI
on(Filename='/databasefiles/les3piliersBI.mdf')
LOG on(Filename='/databasefiles/les3piliersBI_log.ldf')
for attach;

create database les3piliers
on(Filename='/databasefiles/les3piliers.mdf')
LOG on(Filename='/databasefiles/les3piliers_1.ldf')
for attach;

create database les3piliersTest
on(Filename='/databasefiles/les3piliersTest.mdf')
LOG on(Filename='/databasefiles/les3piliersTest_1.ldf')
for attach;