#!/bin/bash

export LD_LIBRARY_PATH=/opt/openssl-1.1.1c/lib
home=/opt/sync_server

cd $home
one=1


for x in 9 8 7 6 5 4 3 2 1
do
  if [ -f server.log.${x} ]
  then
    ext=$((x + one))
    mv server.log.${x} server.log.${ext}
  fi
done

if [ -f server.log ]
then
  mv server.log server.log.1
fi

edit_hosts=`grep passvault /etc/hosts`

if [ "$edit_hosts" == "" ]
then
  server=`ip -4 addr show dev eth0 | grep inet | awk '{print$2}' | awk -F"/" '{print$1}'`; line=`grep ${server} /etc/hosts`; sed "s/${line}/${line} passvault.erikdevelopernot.net/" /etc/hosts > hosts.temp; cat hosts.temp > /etc/hosts
  rm hosts.temp
fi

echo "" >> server.log
echo "" >> server.log
echo "Starting Sync Server" >> server.log
echo `date` >> server.log

echo "Starting Sync Server"
echo `date`

#nohup ./sync_server server.config > server.log 2>&1 &
./sync_server server.config > server.log 2>&1
