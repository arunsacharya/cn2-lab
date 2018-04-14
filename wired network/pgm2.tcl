#2. Simulate the different types of Internet traffic such as FTP and Telnet over a network, Plot congestion window and analyze the throughput.

#creating simulator object
set ns [new Simulator]

#creating trace file
set fin [open pgm2.tr w]
$ns trace-all $fin

#creating nam file
set nfin [open pgm2.nam w]
$ns namtrace-all $nfin

#creating trace file for xgarph
set cwnd1 [open xgraph2a.tr w]
set cwnd2 [open xgraph2b.tr w]

#creating 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#creating channel
$ns duplex-link $n0 $n2 5Mb 2ms DropTail
$ns duplex-link $n1 $n2 5Mb 2ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 10ms DropTail

#attaching TCP agent to the node0 and node3
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0

$ns connect $tcp0 $sink0

#attaching FTP application over node0
set ftp [new Application/FTP]
$ftp attach-agent $tcp0

#schedule FTP event
$ns at 0.2 "$ftp start"
$ns at 1.0 "$ftp stop"

#attaching TCP agent to the node1 and node0
set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $sink1

$ns connect $tcp1 $sink1

#attaching Telnet application over node1
set telnet [new Application/Telnet]
$telnet attach-agent $tcp1

#schedule Telnet event
$ns at 1.2 "$telnet start"
$ns at 2.0 "$telnet stop"

$ns at 5.0 "finish"

proc plotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file" 
}
	
	$ns at 0.2 "plotWindow $tcp0 $cwnd1"
	$ns at 1.2 "plotWindow $tcp1 $cwnd2"

proc finish { } {
	global ns fin nfin cwnd1 cwnd2
	$ns flush-trace
	close $fin
	close $nfin

	puts "running nam..."
	puts "FTP PACKETS.."
	puts "Telnet PACKETS.."
	exec nam pgm2.nam &
        exec xgraph xgraph2a.tr xgraph2b.tr & 
	exit 0
}

#simulation
$ns run
