set ns [new Simulator]
$ns trace-all [open 6.tr w]
$ns namtrace-all [open 6.nam w]

set cwnd0 [open cwnd0.tr w]
set cwnd1 [open cwnd1.tr w]
set cwnd2 [open cwnd2.tr w]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

Queue/RED set queue_in_bytes_ false
Queue/RED set thresh_ 60

$ns duplex-link $n2 $n0 10Mb 10ms DropTail
$ns duplex-link $n3 $n0 10Mb 10ms DropTail
$ns duplex-link $n4 $n0 10Mb 10ms DropTail
$ns duplex-link $n0 $n1 0.7Mb 10ms DropTail

#change the above connection types to either all RED or all DropTail

set tcp0 [new Agent/TCP]
$ns attach-agent $n2 $tcp0
set tcpSink0 [new Agent/TCPSink]
$ns attach-agent $n1 $tcpSink0
$ns connect $tcp0 $tcpSink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns at 1.2 "$ftp0 start"

set tcp1 [new Agent/TCP]
$ns attach-agent $n3 $tcp1
set tcpSink1 [new Agent/TCPSink]
$ns attach-agent $n1 $tcpSink1
$ns connect $tcp1 $tcpSink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 1.2 "$ftp1 start"

set tcp2 [new Agent/TCP]
$ns attach-agent $n4 $tcp2
set tcpSink2 [new Agent/TCPSink]
$ns attach-agent $n1 $tcpSink2
$ns connect $tcp2 $tcpSink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns at 1.2 "$ftp2 start"

proc plotWindow {agent0 file0} {
	global ns
	set time 0.1
	set now [$ns now]
	set CWND [$agent0 set cwnd_]
	puts $file0 "$now $CWND"
	$ns at [expr $now+$time] "plotWindow $agent0 $file0"
}

proc finish { } {
	global ns cwnd0 cwnd1 cwnd2
	$ns flush-trace
	exit 0
}

$ns at 1.0 "plotWindow $tcp0 $cwnd0"
$ns at 1.5 "plotWindow $tcp1 $cwnd1"
$ns at 2.0 "plotWindow $tcp2 $cwnd2"

$ns at 5.0 "finish"
$ns run 


