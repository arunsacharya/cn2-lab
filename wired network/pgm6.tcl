#6. Set up the following topology and analyze the DROPTAIL and RED queue performance. Also plot the congestion window for TCP connections. Write your observation on TCP performance. Bandwidth and delay from each source to the intermediate node are 10Mbps and 10ms respectively. Bandwidth and delay for the bottleneck link are 7 kpbs and 20ms respectively. Assume that each FTP starts at random.

#	       n2			
#		 \
#		  \
#		   \		
#	   n3------n0----------n1
#		   /
#		  /
#		 /	
#	       n4

#creating simulator object
set ns [new Simulator]

#creating 5 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

#creating trace file
set fin [open pgm6.tr w]
$ns trace-all $fin

#creating nam file
set nfin [open pgm6.nam w]
$ns namtrace-all $nfin

#creating trace file for xgraph
set cwnd1 [open xgraph6a.tr w]
set cwnd2 [open xgraph6b.tr w]
set cwnd3 [open xgraph6c.tr w]

#creating channel
$ns duplex-link $n2 $n0 10Mb 10ms DropTail
$ns duplex-link $n3 $n0 10Mb 10ms DropTail
$ns duplex-link $n4 $n0 10Mb 10ms DropTail
$ns duplex-link $n0 $n1 0.7Mb 20ms DropTail

#creating channel Topology
$ns duplex-link-op $n2 $n0 orient right-down
$ns duplex-link-op $n3 $n0 orient right
$ns duplex-link-op $n4 $n0 orient right-up
$ns duplex-link-op $n0 $n1 orient right	 

#attaching TCP agent to the node2 and node0
set tcp0 [new Agent/TCP]
$ns attach-agent $n2 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n1 $sink0

$ns connect $tcp0 $sink0

#attaching FTP application over node2 
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

#attaching TCP agent to the node3 and node0
set tcp1 [new Agent/TCP]
$ns attach-agent $n3 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n1 $sink1

$ns connect $tcp1 $sink1

#attaching FTP application over node3
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1

#attaching TCP agent to the node4 and node0
set tcp2 [new Agent/TCP]
$ns attach-agent $n4 $tcp2

set sink2 [new Agent/TCPSink]
$ns attach-agent $n1 $sink2

$ns connect $tcp2 $sink2

#attaching FTP application over node4
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

#schedule event
$ns at 1.0 "$ftp0 start"
$ns at 2.0 "$ftp1 start"
$ns at 3.0 "$ftp2 start"
$ns at 5.0 "finish"

proc plotWindow {agent file} {
	global ns
	set time 0.10
	set now [$ns now]
	set cwnd [$agent set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $agent $file"
}
	$ns at 1.0 "plotWindow $tcp0 $cwnd1"
	$ns at 2.0 "plotWindow $tcp1 $cwnd2"
	$ns at 3.0 "plotWindow $tcp2 $cwnd3"

proc finish {} {
	global ns fin nfin
	$ns flush-trace
	close $fin
	close $nfin
	puts "running nam..."
	puts "TCP PACKETS.."
	exec nam pgm6.nam &
	exec xgraph xgraph6a.tr xgraph6b.tr xgraph6c.tr &
	exit 0
}

#simulation
$ns run
