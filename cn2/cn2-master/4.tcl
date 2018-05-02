set ns [new Simulator]

$ns trace-all [open 4.tr w]
set nf [open 4.nam w]
$ns namtrace-all $nf

set cwnd0 [open cwnd0.tr w]

set rtproto DV

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set tcpSink0 [new Agent/TCPSink]
$ns attach-agent $n5 $tcpSink0
$ns connect $tcp0 $tcpSink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n4 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail
$ns duplex-link $n3 $n5 1Mb 10ms DropTail

$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n4 orient right
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n5 orient right-up
$ns duplex-link-op $n4 $n5 orient right-down

proc plotWindow { tcpSource file } {
	global ns
	set time 0.01
	set now [$ns now]
	set CWND [$tcpSource set cwnd_]
	puts $file "$now $CWND"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file"
}

$ns at 0.0 "plotWindow $tcp0 $cwnd0"

proc finish { } {
	global ns nf cwnd0
	$ns flush-trace 
	close $nf
	#exec xgraph cong.tr &
	#exec nam ex3nam.nam &
	exit 0
}

$ns rtmodel-at 2.0 down $n1 $n4
$ns rtmodel-at 4.0 up $n1 $n4
$ns at 0.0 "$ftp0 start"
$ns at 6.0 "$ftp0 stop"
$ns at 8.0 "finish"
$ns run
