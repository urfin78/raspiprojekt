#!/bin/bash
while [ true ]
	do
	gpio -g read 27 >> ~/input.log
done
