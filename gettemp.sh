#!/bin/bash
DB="/usr/share/nginx/www/phpprojekt/temphumidity.db"
TIME=`date "+%s"`
SUMH=0
SUMT=0
#read data from sensor until real values are read
for ((i=1; i<=10; i++)); do
	DATA=`~/dht11`
	while [ "${DATA}" = "Invalid Data!!" ]; do
		DATA=`~/dht11`
		TIME=`date "+%s"`
	done
#capture values in array 0=hum,1=temp in celsius
#echo ${DATA}
#echo ${TIME}
	VALUES=($(echo "${DATA}"|grep -oe "[[:digit:]]*\.[[:digit:]]"))
	HUM=($(echo "${VALUES[0]}"|grep -oP '.*?(?=\.)'))
	TEMP=($(echo "${VALUES[1]}"|grep -oP '.*?(?=\.)'))
#	echo ${VALUES[0]}
#	echo ${VALUES[1]}
	SUMH=$(( $SUMH + $HUM ))
	SUMT=$(( $SUMT + $TEMP ))
done
#sqlite3 ${DB} "insert into data (sensor,time,hum,temp) VALUES (1,${TIME},${HUM},${TEMP});"
#echo ${VALUES[0]}
#echo ${VALUES[1]}
HUMID=`echo "scale=1;$SUMH/10"|bc`
TEMPERA=`echo "scale=1;$SUMT/10"|bc`
echo $HUMID
echo $TEMPERA
