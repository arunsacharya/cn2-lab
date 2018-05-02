#!/bin/bash
echo "TCL:-"
ns 2.tcl

#echo "GREP and wordcount on the file: 1.tr"
#grep "^r" 2.tr | wc
echo "AWK command to show throughput."
awk -f 2.awk 2.tr
echo "                                                         "
echo "NAM running"
nam 2.nam &
echo "xgraph running"
/root/Documents/XGRAPH/bin/xgraph cwnd0.tr cwnd1.tr




