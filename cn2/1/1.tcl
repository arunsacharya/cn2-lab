set ns [new Simulator]

#set f [open 1.tr w]
#$ns trace-all f

$ns trace-all [open 1.tr w]

set nf [open 1.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail

$ns queue-limit $n0 $n2 5
$ns queue-limit $n1 $n2 5
$ns queue-limit $n2 $n3 5

set tcp0 [new Agent/TCP]
set tcp1 [new Agent/TCPSink]
$ns attach-agent $n0 $tcp0
$ns attach-agent $n3 $tcp1
$ns connect $tcp0 $tcp1

set udp0 [new Agent/UDP]
set null0 [new Agent/Null]
$ns attach-agent $n1 $udp0
$ns attach-agent $n3 $null0
$ns connect $udp0 $null0

set ftp0 [new Application/FTP]
set cbr0 [new Application/Traffic/CBR]
$ftp0 attach-agent $tcp0
$cbr0 attach-agent $udp0

$ns at 0.2 "$ftp0 start"
$ns at 0.2 "$cbr0 start"
$ns at 2.0 "$ftp0 stop"
$ns at 2.0 "$cbr0 stop"

proc finish { } {
	global ns nf 
	$ns flush-trace
	#close $f
	close $nf
	exec nam 1.nam &
	exit 0
}

$ns at 2.2 "finish"
$ns run


