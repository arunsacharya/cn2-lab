#/bin/bash
echo "Executing TCL file."
ns 8.tcl
echo " "
echo "End of TCL file. Running NAM file."
nam 8.nam &
echo "End of program."
