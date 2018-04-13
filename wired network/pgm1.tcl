#1. Simulate a three nodes point-to-point network with duplex links between them. Set the queue size and vary the bandwidth and find the number of packet dropped.  
set ns [new Simulator]

set fin [open pgm1.tr w]
$ns trace-all $fin

set nfin [open pgm1.nam w]
$ns namtrace-all $nfin

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0

$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
set null [new Agent/Null]
$ns attach-agent $n3 $null

$ns connect $udp0 $null

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

proc finish { } {
	global ns fin nfin
	$ns flush-trace
	close $fin
	close $nfin
	exec nam pgm1.nam &
	exit 0
}

$ns at 0.2 "$ftp0 start"
$ns at 1.0 "$ftp0 stop"
$ns at 1.2 "$cbr0 start"
$ns at 3.0 "$cbr0 stop"
$ns at 5.0 "finish"
$ns run
