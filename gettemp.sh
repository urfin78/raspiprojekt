#!/bin/bash
# initialize variables
TIME=`date "+%s"`
SUMH=0
SUMT=0
# as sensor reads seem to fluctuate do the whole thing 10 times and take the average
for ((i=1; i<=10; i++)); do
# read data from sensor until real values are read
	DATA=`~/dht11`
	while [ "${DATA}" = "Invalid Data!!" ]; do
		DATA=`~/dht11`
		TIME=`date "+%s"`
	done
# capture values in array 0=hum,1=temp in celsius
#
	VALUES=($(echo "${DATA}"|grep -oe "[[:digit:]]*\.[[:digit:]]"))
	HUM=($(echo "${VALUES[0]}"|grep -oP '.*?(?=\.)'))
	TEMP=($(echo "${VALUES[1]}"|grep -oP '.*?(?=\.)'))
	SUMH=$(( $SUMH + $HUM ))
	SUMT=$(( $SUMT + $TEMP ))
done
#sqlite3 ${DB} "insert into data (sensor,time,hum,temp) VALUES (1,${TIME},${HUM},${TEMP});"
# take the average
HUMID=`echo "scale=1;$SUMH/10"|bc`
TEMPERA=`echo "scale=1;$SUMT/10"|bc`
## TODO : what todo withe the DATA
