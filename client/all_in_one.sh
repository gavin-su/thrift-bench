#!/bin/bash

CASEFILE=$1

RESULTFILE=result.txt.$CASEFILE
> $RESULTFILE

while read CON TIMES
do
    LOGFILE=log.$CASEFILE.$CON.$TIMES
    > $LOGFILE

    ./batch_cli.py $CON $TIMES > $LOGFILE
    echo -n "$CON   $TIMES    " >> $RESULTFILE
    ERR=`cat $LOGFILE | grep err | wc -l`
    TIMEOUT=`cat $LOGFILE | grep err| grep timeout | wc -l`
    OTHERERR=`echo $ERR - $TIMEOUT | bc`
    echo -n "$TIMEOUT   $OTHERERR  " >> $RESULTFILE
    cat $LOGFILE | grep -v err | grep used | awk 'BEGIN{line=0;tot=0; max=0; min=4294967295;}{++line;tot+=$2; if(max<$2){max=$2}; if(min>$2){min=$2}; }END{printf "%0.2f\t%0.2f\t%0.2f\t", max/1000, min/1000, tot/line/1000}' >> $RESULTFILE 
    STDDEVRESULTFILE=stdev.$LOGFILE
    > $STDDEVRESULTFILE

    cat $LOGFILE | grep -v err | grep used | awk '{printf "%0.2f\n", $2/1000}' >> $STDDEVRESULTFILE

    LINE=`wc -l $STDDEVRESULTFILE | awk '{print $1}'`

    if [ "${LINE}" -le "1" ]
    then
        exit 0
    fi

    STDDEV=`./calc_stdev.py $STDDEVRESULTFILE`
    echo -n $STDDEV"    " >> $RESULTFILE

    echo "" >> $RESULTFILE
    sleep 5
done < $CASEFILE 
