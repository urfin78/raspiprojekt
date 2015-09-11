#!/bin/bash
#variablen
DB="/root/test.db"
WRONGTEMP=true
#
while [ ${WRONGTEMP} = true ]; do
  TEMP=`sqlite3 ${DB} 'select id from data where temp > 50 limit 1'`;
  if [ ${TEMP} ]; then
    BEFORETEMP=`sqlite3 ${DB} 'select temp from data where id='${TEMP}-1''`;
    AFTERTEMP=`sqlite3 ${DB} 'select temp from data where id='${TEMP}+1''`;
    NEWTEMP=`echo "scale=2;(${AFTERTEMP}+${BEFORETEMP})/2"|bc`;
    sqlite3 ${DB} "update data set temp=${NEWTEMP} where id=${TEMP}";
#debugecho
#echo "ID: ${TEMP} temp:${BEFORETEMP} temp2: ${AFTERTEMP} AVG:${NEWTEMP}";
  else
    WRONGTEMP=wrong;
#debugecho
#	echo "kein"
  fi
done
