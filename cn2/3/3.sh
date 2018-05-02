#!/bin/bash
echo "Running TCL file"
ns 3.tcl
echo "Running NAM - Network animator"
nam 3.nam &
echo "Running XGRAPH"
/root/Documents/XGRAPH/bin/xgraph cwnd0.tr cwnd1.tr

