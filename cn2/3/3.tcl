set ns [new Simulator]

$ns trace-all [open 3.tr w]
set nf [open 3.nam w]
$ns namtrace-all $nf
set cwnd0 [open cwnd0.tr w]
set cwnd1 [open cwnd1.tr w]

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]

set lan0 [$ns newLan "$n0 $n1 $n2 $n3 $n4 $n5 $n6 $n7 $n8 $n9" 0.5Mb 10ms LL Queue/DropTail MAC Csma/Cd Channel]

$ns duplex-link $n5 $n6 1Mb 10ms DropTail

set tcp0 [new Agent/TCP]
set tcpSink0 [new Agent/TCPSink]
$ns attach-agent $n1 $tcp0
$ns attach-agent $n8 $tcpSink0
$ns connect $tcp0 $tcpSink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set tcp1 [new Agent/TCP]
set tcpSink1 [new Agent/TCPSink]
$ns attach-agent $n7 $tcp1
$ns attach-agent $n3 $tcpSink1
$ns connect $tcp1 $tcpSink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

proc plotWindow { tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set CWND [$tcpSource set cwnd_]
	puts $file "$now $CWND"
	$ns at [expr $now + $time] "plotWindow $tcpSource $file"
}

$ns at 0.0 "plotWindow $tcp0 $cwnd0"
$ns at 0.0 "plotWindow $tcp1 $cwnd1"

proc finish { } {
	global ns nf cwnd0 cwnd1
	$ns flush-trace
	close $nf
	exit 0
}
$ns at 0.2 "$ftp0 start"
$ns at 2.0 "$ftp0 stop"
$ns at 2.2 "$ftp1 start"
$ns at 4.0 "$ftp1 stop"
$ns at 5.0 "finish"

$ns run

