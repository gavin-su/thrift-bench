#!/bin/bash

LOGFILE=$1

RESULTFILE=stdev.$LOGFILE

cat $LOGFILE | grep -v err | grep used | awk '{printf "%0.2f\n", $2/1000}' >> $RESULTFILE

LINE=`wc -l $RESULTFILE | awk '{print $1}'`

if [ "${LINE}" -le "1" ]
then
    exit 0
fi

./calc_stdev.py $RESULTFILE

