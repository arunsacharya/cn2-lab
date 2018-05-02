set val(chan)        Channel/WirelessChannel
set val(prop)        Propagation/TwoRayGround
set val(netif)       Phy/WirelessPhy
set val(mac)         Mac/802_11
set val(ifq)         CMUPriQueue 
#for DSR
#set val(ifq)         Queue/DropTail/PriQueue    
#for DSDV annd AODV
set val(ll)          LL
set val(ant)         Antenna/OmniAntenna
set val(x)           500    
set val(y)           400    
set val(ifqlen)      50        
set val(nn)          3        
set val(stop)        60.0        
set val(rp)          DSR

#AODV ; DSDV ; DSR  


set ns [new Simulator]  
$ns trace-all [open 9.tr w]

set namtrace [open 9.nam w]
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

set prop    [new $val(prop)]
set topo    [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

#Node Configuration                 

        $ns node-config -adhocRouting $val(rp) \
             -llType $val(ll) \
             -macType $val(mac) \
             -ifqType $val(ifq) \
             -ifqLen $val(ifqlen) \
             -antType $val(ant) \
             -propType $val(prop) \
             -phyType $val(netif) \
             -channelType $val(chan) \
             -topoInstance $topo \
             -agentTrace ON \
             -routerTrace ON \
             -macTrace ON

#Creating Nodes                     
for {set i 0} {$i < $val(nn) } {incr i} {
     set node($i) [$ns node]    
     $node($i) random-motion 0    
     }

#Initial Positions of Nodes            
$node(0) set x_ 5.0
$node(0) set y_ 5.0
$node(0) set z_ 0.0

$node(1) set x_ 490.0
$node(1) set y_ 285.0
$node(1) set z_ 0.0

$node(2) set x_ 150.0
$node(2) set y_ 240.0
$node(2) set z_ 0.0


for {set i 0} {$i < $val(nn)} {incr i} {
    $ns initial_node_pos $node($i) 40
}

#Topology Design    

$ns at 0.0 "$node(0) setdest 450.0 285.0  30.0"
$ns at 0.0 "$node(1) setdest 200.0 285.0 30.0"
$ns at 0.0 "$node(2) setdest 1.0 285.0 30.0"


$ns at 25.0 "$node(0) setdest 300.0 285.0 10.0"
$ns at 25.0 "$node(2) setdest 100.0 285.0 10.0"


$ns at 40.0 "$node(0) setdest 490.0 285.0  5.0"
$ns at 40.0 "$node(2) setdest 1.0 285.0 5.0"
             

#Generating Traffic                
   set tcp0 [new Agent/TCP]
   set tcpSink0 [new Agent/TCPSink]
   $ns attach-agent $node(0) $tcp0
   $ns attach-agent $node(2) $tcpSink0
   $ns connect $tcp0 $tcpSink0
   set ftp0 [new Application/FTP]
   $ftp0 attach-agent $tcp0
   $ns at 10.0 "$ftp0 start" 
   

#Simulation Termination                 

for {set i 0} {$i < $val(nn) } {incr i} {
    $ns at $val(stop) "$node($i) reset";
    }
    $ns at $val(stop) "puts \"NS EXITING...\" ; $ns halt"

puts "Starting Simulation..."
     $ns run

#Repeat the simulation for AODV and DSR Routing protocols.

