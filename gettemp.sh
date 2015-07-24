#!/bin/bash
DB="/usr/share/nginx/www/phpprojekt/temphumidity.db"
DATA=`/usr/local/bin/dht11_wpi29`
TIME=`date "+%s"`
#read data from sensor until real values are read
while [ "${DATA}" = "Invalid Data!!" ]; do
	DATA=`/usr/local/bin/dht11_wpi29`
	TIME=`date "+%s"`
done
#capture values in array 0=hum,1=temp in celsius, 2=temp in fahrenheit
echo ${DATA}
echo ${TIME}
VALUES=($(echo "${DATA}"|grep -oe "[[:digit:]]*\.[[:digit:]]"))
HUM=${VALUES[0]}
TEMP=${VALUES[1]}
sqlite3 ${DB} "insert into data (sensor,time,hum,temp) VALUES (1,${TIME},${HUM},${TEMP});"
echo ${VALUES[0]}
echo ${VALUES[1]}
echo ${VALUES[2]}
