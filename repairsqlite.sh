#!/bin/bash
#variablen
DB=
WRONGTEMP=true
#
while [ ${WRONGTEMP} = true ]; do
  TEMP=`sqlite3 ${DB} "select id from data where temp > 50 limit 1"`;
  if [ ${TEMP} ]; then
    BEFORETEMP=`sqlite3 ${DB} "select temp from data where id='${TEMP}-1'"`;
    AFTERTEMP=`sqlite3 ${DB} "select temp from data where id='${TEMP}+1'"`;
    NEWTEMP=`echo "scale=2;(${AFTERTEMP}+${BEFORETEMP})/2"|bc`;
    sqlite3 ${DB} "update data set temp=${NEWTEMP} where id=${TEMP}`;
  else
    WRONGTEMP=wrong;
  fi
done
