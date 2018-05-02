#!/bin/bash
echo "Executing 1.tcl"
ns 1.tcl
echo "GREP : Giving the word count of the number of lines / words / characters :-"
grep "^r" 1.tr | wc
echo "AWK command which gives us the number of packets delivered / dropped."
awk  -f 1.awk 1.tr



