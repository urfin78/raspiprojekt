#!/bin/bash
#DB="/root/test.db"
DB="test.db"
#RRD="/root/temphum.rrd"
RRD="newtemp.rrd"
TIME=`date "+%s"`
#YESTERDAY="${TIME}-36000"
YESTERDAY="${TIME}-1800"
echo '#!/bin/bash' > 2rrd.sh
#sqlite3 ${DB} "select time,temp,hum from data where time > ${YESTERDAY};"|sed 's/|/\:/g'|sed 's/^/rrdtool update \/root\/temphum.rrd /' >> 2rrd.sh
#sqlite3 ${DB} "select time,temp,hum from data;"|sed 's/|/\:/g'|sed 's/^/rrdtool update newtemp.rrd /' >> 2rrd.sh
sqlite3 ${DB} "select time,temp,hum from data where time > ${YESTERDAY};"|sed 's/|/\:/g'|sed 's/^/rrdtool update newtemp.rrd /' >> 2rrd.sh
