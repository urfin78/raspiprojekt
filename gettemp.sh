#!/bin/bash
DB="/root/test.db"
RRD="/root/temphum.rrd"
TIME=`date "+%s"`
SUMH=0
SUMT=0
#read data from sensor until real values are read
for ((i=1; i<=10; i++)); do
	DATA=`~/loldht 7|tail -n1|cut -f 3,7 -d " "`
#	DATA=`~/dht11`
#	while [ "${DATA}" = "Invalid Data!!" ]; do
#		DATA=`~/dht11`
#		TIME=`date "+%s"`
#	done
#capture values in array 0=hum,1=temp in celsius
	VALUES=($(echo "${DATA}"|grep -oe "[[:digit:]]*\.[[:digit:]][[:digit:]]"))
	HUM=($(echo "${VALUES[0]}"))
	TEMP=($(echo "${VALUES[1]}"))
	SUMH=`echo "scale=2;$SUMH+$HUM"|bc`
	SUMT=`echo "scale=2;$SUMT+$TEMP"|bc`
#dht 11
#	VALUES=($(echo "${DATA}"|grep -oe "[[:digit:]]*\.[[:digit:]]"))
#	HUM=($(echo "${VALUES[0]}"|grep -oP '.*?(?=\.)'))
#	TEMP=($(echo "${VALUES[1]}"|grep -oP '.*?(?=\.)'))
#	SUMH=$(( $SUMH + $HUM ))
#	SUMT=$(( $SUMT + $TEMP ))
done
HUMID=`echo "scale=2;$SUMH/10"|bc`
TEMPERA=`echo "scale=2;$SUMT/10"|bc`
#HUMID=`echo "scale=1;$SUMH/10"|bc`
#TEMPERA=`echo "scale=1;$SUMT/10"|bc`
#fill both databases
rrdtool update ${RRD} ${TIME}:${TEMPERA}:${HUMID}
sqlite3 ${DB} "insert into data (time,hum,temp) VALUES (${TIME},${HUMID},${TEMPERA});"
#copy to www
cp $DB /var/www/
#create rrd graph
START=1438424408
MAX=`rrdtool graph ${RRD} --start=${START} DEF:max="${RRD}":TEMP:MAX VDEF:maxi=max,MAXIMUM PRINT:maxi:"%4.2lf %s"|tail -n 1`
MIN=`rrdtool graph ${RRD} --start=${START} DEF:min="${RRD}":TEMP:MAX VDEF:mini=min,MINIMUM PRINT:mini:"%4.2lf %s"|tail -n 1`
ULIMIT=`echo "scale=2;$MAX+5"|bc`
LLIMIT=`echo "scale=2;$MIN-5"|bc`
rrdtool graph /var/www/temperature.gif --start ${START} \
	--title="Temperatur" \
	-w 600 -h 200 \
	--alt-autoscale-max \
	--lower-limit ${LLIMIT} \
	--upper-limit ${ULIMIT} \
	--vertical-label "Temperature" \
	DEF:temp=${RRD}:TEMP:AVERAGE \
	DEF:max=${RRD}:TEMP:MAX:step=86400 \
	DEF:min=${RRD}:TEMP:MIN:step=86400 \
	COMMENT:"Temperatur in °C \l" \
	LINE1:temp#00EE00:"Durchschnitt\:" \
	GPRINT:temp:AVERAGE:"%6.2lf %s" \
	LINE2:max#ff0000:"Max\:" \
	GPRINT:max:MAX:"%6.2lf %s" \
	LINE3:min#0000ff:"Min\:" \
	GPRINT:min:MIN:"%6.2lf %s" \
