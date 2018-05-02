#!/bin/bash
echo "Running TCL file."
ns 6.tcl
echo "Runing NAM file."
nam 6.nam &
echo "GREP command to find number of packets delivered (piped to word count)"
echo " "
grep "^d" 6.tr | wc
echo "Running XGRAPH."
/root/Documents/XGRAPH/bin/xgraph cwnd0.tr cwnd1.tr cwnd2.tr 

