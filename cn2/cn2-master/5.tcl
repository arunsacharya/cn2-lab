set ns [new Simulator]
$ns trace-all [open 5.tr w]
$ns namtrace-all [open 5.nam w]

set n0 [$ns node]
set n1 [$ns node]

$n0 label 'Server'
$n1 label 'Client'

set tcp0 [new Agent/TCP]
set tcpSink0 [new Agent/TCPSink]
$ns attach-agent $n0 $tcp0
$ns attach-agent $n1 $tcpSink0
$ns connect $tcp0 $tcpSink0

$tcp0 set packetSize = 1500
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link-op $n0 $n1 orient right

proc finish {  } {
	global ns
	$ns flush-trace
	exit 0
}

$ns at 0.0 "$ftp0 start"
$ns at 5.0 "$ftp0 stop"
$ns at 6.0 "finish"

$ns run



