#!/bin/bash
#graph creation
START=1438424408
RRD="/root/temphum.rrd"
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
	DEF:max=${RRD}:TEMP:MAX \
	DEF:min=${RRD}:TEMP:MIN \
	COMMENT:"Temperatur in °C \l" \
	LINE1:temp#00EE00:"Durchschnitt\:" \
	GPRINT:temp:AVERAGE:"%6.2lf %s" \
	LINE2:max#ff0000:"Max\:" \
	GPRINT:max:MAX:"%6.2lf %s" \
	LINE3:min#0000ff:"Min\:" \
	GPRINT:min:MIN:"%6.2lf %s" \
