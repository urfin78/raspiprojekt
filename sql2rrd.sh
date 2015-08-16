#!/bin/bash
DB="/root/test.db"
RRD="/root/temphum.rrd"
TIME=`date "+%s"`
YESTERDAY="${TIME}-86400"
echo '#!/bin/bash' > 2rrd.sh
sqlite3 ${DB} "select time,temp,hum from data where time > ${YESTERDAY};"|sed 's/|/\:/g'|sed 's/^/rrdtool update \/root\/temphum.rrd /' >> 2rrd.sh
