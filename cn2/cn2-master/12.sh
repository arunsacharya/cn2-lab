#!/bin/bash
echo "Running TCL file"
ns 12.tcl
echo "Running NAM file"
nam 12.nam &
echo "End of program 12."
