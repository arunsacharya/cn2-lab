#!/bin/bash
echo "Choose the typre of protocol in the TCL file:- AODV;DSDV;DSR" 
echo "Running TCL file"
ns 9.tcl
echo "TCL file completed. Running NAM file."
nam 9.nam &
echo "END of program"
