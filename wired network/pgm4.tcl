#4. Set up the topology with 6 nodes, and demonstrate the working of Distance vector routing protocol. The link between 1 and 4 breaks at 1.0ms and comes up at 3.0ms. Assume that the source node 0 transmits packets to node 4. Plot the congestion window when TCP sends packets via other nodes. Assume your own parameters for bandwidth and delay. 
#			n1--------------n4
#			/		 \ 
#		       /  		  \
#		      /			   \
#		     n0			   n5
#		      \			   /	
#		       \		  /
#		        \		 /		
#			n2--------------n3

#creating simulator object 
set ns [new Simulator]

#creating trace file
set fin [open pgm4.tr w]
$ns trace-all $fin

#creating nam file
set nfin [open pgm4.nam w]
$ns namtrace-all $nfin

#creating trace file for xgraph
set cwnd [open xgraph4.tr w]

#simulating Distance vector routing protocol
$ns rtproto DV

$ns color 1 Blue 
$ns color 2 Red

#creating 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#creating channel
$ns duplex-link $n0 $n1 0.3Mb 10ms DropTail
$ns duplex-link $n1 $n4 0.3Mb 10ms DropTail
$ns duplex-link $n4 $n5 0.3Mb 10ms DropTail
$ns duplex-link $n0 $n2 0.3Mb 10ms DropTail
$ns duplex-link $n2 $n3 0.5Mb 10ms DropTail
$ns duplex-link $n3 $n5 0.5Mb 10ms DropTail

#creating channel topology
$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n1 $n4 orient right
$ns duplex-link-op $n4 $n5 orient right-down
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n5 orient right-up

#attaching TCP agent to the node0 and node4 
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink

$ns connect $tcp $sink
$tcp set fid_ 1

#attaching FTP application over node0
set ftp [new Application/FTP]
$ftp attach-agent $tcp

#The link between node1 and node4 breaks at 1.0ms
$ns rtmodel-at 1.0 down $n1 $n4

#The link between node1 and node4 comes up at 3.0ms
$ns rtmodel-at 3.0 up $n1 $n4

#schedule event
$ns at 0.2 "$ftp start"
$ns at 10.0 "finish"

proc plotWindow {tcpSource file} {
	global ns
	set time 0.01
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $file "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $file" 
}
$ns at 1.0 "plotWindow $tcp $cwnd"

proc finish {} {
	global ns fin nfin cwnd
	$ns flush-trace
	close $fin
	close $nfin
	exec nam pgm4.nam &
        exec xgraph xgraph4.tr & 
	exit 0
}

#simulation
$ns run
