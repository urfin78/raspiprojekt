#!/bin/bash
#graph creation
rrdtool graph /var/www/temperature.gif --start 1438424408 --end N --title="Temperatur"	-w 600 -h 200 --alt-autoscale-max --lower-limit 0 --vertical-label "Temperature" DEF:temp=temphum.rrd:TEMP:AVERAGE DEF:max=temphum.rrd:TEMP:MAX DEF:min=temphum.rrd:TEMP:MIN COMMENT:"Temperatur in °C \l" GPRINT:temp:MAX:"IN %6.2lf %s\:" GPRINT:temp:MIN:"%6.2lf %s\:" GPRINT:temp:AVERAGE:"%6.2lf %s\:" AREA:temp#00EE00:"Temp °C \l" LINE1:max#ff0000:"max" LINE2:min#0000ff:"min"
