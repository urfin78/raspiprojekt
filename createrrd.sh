#!/bin/bash
FILENAME=$1
rrdtool create --start 1438424400 ${FILENAME}.rrd DS:TEMP:GAUGE:600:-50:70 DS:HUM:GAUGE:600:0:100 RRA:AVERAGE:0.5:1:576 RRA:MAX:0.5:1:576 RRA:MIN:0.5:1:576 RRA:AVERAGE:0.5:4:504 RRA:MAX:0.5:4:504 RRA:MIN:0.5:4:504 RRA:AVERAGE:0.5:12:336 RRA:MAX:0.5:12:336 RRA:MIN:0.5:12:336 RRA:AVERAGE:0.5:24:372 RRA:MAX:0.5:24:372 RRA:MIN:0.5:24:372 RRA:AVERAGE:0.5:72:744 RRA:MAX:0.5:72:744 RRA:MIN:0.5:72:744 RRA:AVERAGE:0.5:144:744 RRA:MAX:0.5:144:744 RRA:MIN:0.5:144:744 RRA:AVERAGE:0.5:288:18000 RRA:MAX:0.5:288:18000 RRA:MIN:0.5:288:18000
