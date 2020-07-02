#!/bin/bash

#chown postgres:postgres /pg_hba.conf 
#chown postgres:postgres /postgresql.conf

#chmod 644 /pg_hba.conf
#chmod 644 /postgresql.conf

cp -rf /pg_hba.conf /var/lib/postgresql/data
cp -rf /postgresql.conf /var/lib/postgresql/data

