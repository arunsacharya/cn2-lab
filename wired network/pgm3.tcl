#3. Setup the LAN network with 10 nodes, duplex-link node 5 to node 6 is 1Mb and 10ms. N1(source) and N8(sink), N7(source) and N3(sink). Plot congestion window for different source/destination.

#creating simulator object
set ns [new Simulator]

#creating trace file
set fin [open pgm3.tr w]
$ns trace-all $fin

#creating nam file
set nfin [open pgm3.nam w]
$ns namtrace-all $nfin

#creating trace file for xgraph
set cwnd1 [open xgraph3a.tr w]
set cwnd2 [open xgraph3b.tr w]

#creating 10 nodes
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]

#creating lan connection
set lan [$ns newLan "$n1 $n2 $n3 $n4 $n5  $n6 $n7 $n8 $n9 $n10 "  10Mb 2ms LL Queue/DropTail Channel]
$ns duplex-link $n5 $n6 1Mb 10ms DropTail

#attaching TCP agent to the node1 and node8
set tcp0 [new Agent/TCP]
$ns attach-agent $n1 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n8 $sink0

$ns connect $tcp0 $sink0

#attaching FTP aplication over node1
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

#attaching TCP agent to the node7 and node3
set tcp1 [new Agent/TCP]
$ns attach-agent $n7 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n3 $sink1

$ns connect $tcp1 $sink1

#attaching FTP application over node7 
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

#schedule event
$ns at 1.0  "$ftp0 start"
$ns at 2.0  "$ftp1 start"
$ns at 10.0 "finish"

proc plotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file" 
}

$ns at 2.0 "plotWindow $tcp0 $cwnd1"
$ns at 5.5 "plotWindow $tcp1 $cwnd2"

proc finish {} 	{
	global ns fin nfin cwnd1 cwnd2
	$ns flush-trace
	close $fin
	close $nfin
	puts "running nam..."
	exec xgraph xgraph3a.tr xgraph3b.tr &
	exec nam pgm3.nam &
	exit 0
}

#simulation	
$ns run
