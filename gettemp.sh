#!/bin/bash
DB="/root/test.db"
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
	VALUES=($(echo "${DATA}"|grep -oe "[[:digit:]]*\.[[:digit:]]"))
	HUM=($(echo "${VALUES[0]}"|grep -oP '.*?(?=\.)'))
	TEMP=($(echo "${VALUES[1]}"|grep -oP '.*?(?=\.)'))
#	echo ${VALUES[0]}
#	echo ${VALUES[1]}
	SUMH=$(( $SUMH + $HUM ))
	SUMT=$(( $SUMT + $TEMP ))
done
#echo ${VALUES[0]}
#echo ${VALUES[1]}
HUMID=`echo "scale=1;$SUMH/10"|bc`
TEMPERA=`echo "scale=1;$SUMT/10"|bc`
sqlite3 ${DB} "insert into data (time,hum,temp) VALUES (${TIME},${HUMID},${TEMPERA});"
#echo $HUMID
#echo $TEMPERA
cp $DB /var/www/
