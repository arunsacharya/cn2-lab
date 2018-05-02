#!/bin/bash
echo "TCL file"
ns 4.tcl
echo "NAM file"
nam 4.nam &
echo "XGraph"
/root/Documents/XGRAPH/bin/xgraph cwnd0.tr 
