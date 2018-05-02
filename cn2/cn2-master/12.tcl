set val(chan)        Channel/WirelessChannel    ;#channel type
set val(prop)        Propagation/TwoRayGround    ;#radio-propagation model
set val(netif)       Phy/WirelessPhy        ;#network interface type
set val(mac)         Mac/802_11            ;#MAC type
set val(ifq)         Queue/DropTail/PriQueue    ;#interface queue type
set val(ll)          LL                    ;#link layer type
set val(ant)         Antenna/OmniAntenna        ;#antenna model
set val(ifqlen)      50                    ;#max packet in ifq

set ns [new Simulator]

$ns trace-all [open 12.tr w]
set nf [open 12.nam w]
$ns namtrace-all-wireless $nf 100 100


$ns node-config  -llType $val(ll) \
                 -macType $val(mac) \
                 -ifqType $val(ifq) \
                 -ifqLen $val(ifqlen) \
                 -antType $val(ant) \
                 -propType $val(prop) \
                 -phyType $val(netif) \
                 -channelType $val(chan) \
             
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

set lan [$ns newLan "$n0 $n1 $n2 $n3 $n4 $n5" 0.5Mb 30ms LL Queue/DropTail Mac/802_11 Channel/WirelessChannel]


set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n5 $sink0

$ns connect $tcp0 $sink0

$ns at 5.000000 "$ftp0 start"

proc finish {}     {
	global ns nf
	$ns flush-trace
	close $nf
	exit 0
}
$ns at 60.0000 "finish"    
$ns run

