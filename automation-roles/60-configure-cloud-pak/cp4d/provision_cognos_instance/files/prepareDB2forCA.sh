#! /bin/bash

export DATABASE=$1
export DB2USERNAME=$2
export DB2PASSWORD=$3

if [ -z "${DATABASE}" ]; then
 echo "No Database provided.."
 exit 1
fi

if [ -z "${DB2USERNAME}" ]; then
 echo "No Database user name provided.."
 exit 1
fi

if [ -z "${DB2PASSWORD}" ]; then
 echo "No Database user password provided.."
 exit 1
fi

cd /mnt/blumeta0/home/db2inst1/sqllib
. ./db2profile

db2 CONNECT to ${DATABASE} user ${DB2USERNAME} using  ${DB2PASSWORD};
db2 UPDATE DATABASE CONFIGURATION USING APPLHEAPSZ 1024 DEFERRED;
db2 UPDATE DATABASE CONFIGURATION USING LOCKTIMEOUT 240 DEFERRED;
db2 CREATE BUFFERPOOL CMDB_08KBP IMMEDIATE SIZE 1000 PAGESIZE 8K;
db2 CREATE BUFFERPOOL CMDB_32KBP IMMEDIATE SIZE 1000 PAGESIZE 32K;
db2 CREATE SYSTEM TEMPORARY TABLESPACE TSN_SYS_CMDB IN DATABASE PARTITION GROUP IBMTEMPGROUP PAGESIZE 32K BUFFERPOOL CMDB_32KBP;
db2 CREATE USER TEMPORARY TABLESPACE TSN_USR_CMDB IN DATABASE PARTITION GROUP IBMDEFAULTGROUP PAGESIZE 8K BUFFERPOOL CMDB_08KBP;
db2 CREATE REGULAR TABLESPACE TSN_REG_CMDB IN DATABASE PARTITION GROUP IBMDEFAULTGROUP PAGESIZE 8K BUFFERPOOL CMDB_08KBP;
db2 CREATE SCHEMA db2COGNOS AUTHORIZATION ${DB2USERNAME};
db2 ALTER BUFFERPOOL ibmdefaultbp size 49800;