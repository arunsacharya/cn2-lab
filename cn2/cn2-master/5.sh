#!/bin/bash
echo "TCL file running."
ns 5.tcl
echo "NAM file"
nam 5.nam &
echo "AWK scripts running"
awk -f 5_0.awk 5.tr &
awk -f 5_1.awk 5.tr > 5.dat &
echo "XGRAPH running"
/root/Documents/XGRAPH/bin/xgraph 5.dat 
