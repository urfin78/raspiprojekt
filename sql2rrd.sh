#!/bin/bash
DB="/root/test.db"
TIME=`date "+%s"`
sqlite3 ${DB} "select time,temp,hum from data;"|sed 's/|/\:/g'|sed 's/^/rrdtool update temphum.rrd /' > 2rrd.sh
