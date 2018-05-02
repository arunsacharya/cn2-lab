set ns [new Simulator -multicast on]

$ns trace-all [open 7.tr w]
$ns namtrace-all [open 7.nam w]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]

$n2 label 'Group1'
$n3 label 'Group1'
$n4 label 'Group1'
$n5 label 'Group0'
$n6 label 'Group0'
$n7 label 'Group0'

$ns duplex-link $n0 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n4 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n7 1.5Mb 10ms DropTail
$ns duplex-link $n4 $n5 1.5Mb 10ms DropTail
$ns duplex-link $n4 $n6 1.5Mb 10ms DropTail

set mproto0 DM
set mrthandle0 [$ns mrtproto $mproto0 {}]
set group0 [Node allocaddr]
set group1 [Node allocaddr]

set udp0 [new Agent/UDP]
set cbr0 [new Application/Traffic/CBR]
$ns attach-agent $n0 $udp0
$udp0 set dst_addr_ $group0
$udp0 set dst_port_ 0
$cbr0 attach-agent $udp0

set udp1 [new Agent/UDP]
set cbr1 [new Application/Traffic/CBR]
$ns attach-agent $n1 $udp1
$udp1 set dst_addr_ $group1
$udp1 set dst_port_ 0
$cbr1 attach-agent $udp1

set recv0 [new Agent/Null]
set recv1 [new Agent/Null]
set recv2 [new Agent/Null]
set recv3 [new Agent/Null]
set recv4 [new Agent/Null]
set recv5 [new Agent/Null]

$ns attach-agent $n5 $recv0
$ns attach-agent $n6 $recv1
$ns attach-agent $n7 $recv2
$ns attach-agent $n2 $recv3
$ns attach-agent $n3 $recv4
$ns attach-agent $n4 $recv5

proc finish { } {
	global ns 
	$ns flush-trace
	exit 0
}

$ns at 1.0 "$n5 join-group $recv0 $group0"
$ns at 1.5 "$n6 join-group $recv1 $group0"
$ns at 2.0 "$n7 join-group $recv2 $group0"
$ns at 2.5 "$n2 join-group $recv3 $group1"
$ns at 3.0 "$n3 join-group $recv4 $group1"
$ns at 3.5 "$n4 join-group $recv5 $group1"

$ns at 4.0 "$n5 leave-group $recv0 $group0"
$ns at 4.5 "$n6 leave-group $recv1 $group0"
$ns at 5.0 "$n7 leave-group $recv2 $group0"
$ns at 5.5 "$n2 leave-group $recv3 $group1"
$ns at 6.0 "$n3 leave-group $recv4 $group1"
$ns at 6.5 "$n4 leave-group $recv5 $group1"

$ns at 0.5 "$cbr0 start"
$ns at 0.5 "$cbr1 start"
$ns at 9.5 "$cbr0 stop"
$ns at 9.5 "$cbr1 stop"
$ns at 10.0 "finish"

$ns run

