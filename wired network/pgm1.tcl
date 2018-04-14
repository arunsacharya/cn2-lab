#1. Simulate a four node point-to-point network with duplex link as follows: n0-n2, n1-n2 and n2-n3. Apply TCP agent between n0-n3 and UDP agent between n1-n3. Apply relevant applications over TCP and UDP agents. Set the queue size and vary the bandwidth to find the number of packet dropped and received by TCP/UDP using awk script and grep command.  

#creating simulator object
set ns [new Simulator]

#creating trace file
set fin [open pgm1.tr w]
$ns trace-all $fin

#creating nam file
set nfin [open pgm1.nam w]
$ns namtrace-all $nfin

#creating 4 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#creating channel
$ns duplex-link $n0 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 5ms DropTail
$ns duplex-link $n2 $n3 1.5Mb 5ms DropTail

#attaching TCP agent to the node0 and node3
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0

$ns connect $tcp0 $sink0

#attaching FTP application over node0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

#attaching UDP agent to the node1 and node3
set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
set null [new Agent/Null]
$ns attach-agent $n3 $null

$ns connect $udp0 $null

#attaching CBR application over node1
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

#schedule event
$ns at 0.2 "$ftp0 start"
$ns at 1.0 "$ftp0 stop"
$ns at 1.2 "$cbr0 start"
$ns at 3.0 "$cbr0 stop"
$ns at 5.0 "finish"

#simulation
$ns run
