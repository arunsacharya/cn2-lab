set ns [new Simulator]

$ns trace-all [open 2.tr w]
set nf [open 2.nam w]
$ns namtrace-all $nf

set cwnd0 [open cwnd0.tr w]
set cwnd1 [open cwnd1.tr w]
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 45.5MB 5ms DropTail
$ns duplex-link $n1 $n2 25.0MB 15ms DropTail
$ns duplex-link $n2 $n3 15.6MB 5ms DropTail

$ns queue-limit $n0 $n2 12
$ns queue-limit $n2 $n3 20

set tcp0 [new Agent/TCP]
set tcpsink0 [new Agent/TCPSink]
$ns attach-agent $n0 $tcp0
$ns attach-agent $n3 $tcpsink0
$ns connect $tcp0 $tcpsink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0



set tcp1 [new Agent/TCP]
set tcpsink1 [new Agent/TCPSink]
$ns attach-agent $n1 $tcp1
$ns attach-agent $n3 $tcpsink1
$ns connect $tcp1 $tcpsink1
set tel0 [new Application/Telnet]
$tel0 attach-agent $tcp1

proc plotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set CWND [$tcpSource set cwnd_]
	puts $file "$now $CWND"
	$ns at [ expr $now + $time] "plotWindow $tcpSource $file"
}

$ns at 0.0 "plotWindow $tcp0 $cwnd0"
$ns at 0.0 "plotWindow $tcp1 $cwnd1"

proc finish { } {
	global ns nf
	$ns flush-trace
	close $nf
	#exec nam 2.nam &
	#exec xgraph cwnd0.tr &
	exit 0
}

$ns at 0.0 "$ftp0 start"
$ns at 1.0 "$tel0 start"
$ns at 4.0 "$ftp0 stop"
$ns at 4.0 "$tel0 stop"
$ns at 5.0 "finish"

$ns run



