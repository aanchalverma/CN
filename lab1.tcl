#Create a simulator object
  set  ns  [new Simulator]

#Open a trace file
  set  nt  [open  lab1.tr  w]
  $ns  trace-all  $nt

#Open a nam trace file
  set  nf  [open lab1.nam W]
  $ns  namtrace-all  $nf

# Create the nodes.
  set  n0  [$ns node]
  set  n1  [$ns node]
  set  n2  [$ns node]
  set  n3  [$ns node]

#Assign color to the packets.
  $ns  color  1  Red
  $ns  color  2  Blue

#Label the nodes
  $n0  label  "Source/udp0"
  $n1  label  "Source/udp1"
  $n2  label  "Router"
  $n3  label  "Destination/Null"

#Create links, vary bandwidth to check the number of packets dropped.
  $ns  duplex-link  $n0  $n2  10Mb  30ms  DropTail
  $ns  duplex-link  $n1  $n2  10Mb  30ms  DropTail
  $ns  duplex-link  $n2 $n3  1Mb  30ms  Drop?Tail
# Set the queue size between the nodes
  $ns  set queue-limit  $n0  $n2  10
  $ns  set  queue-limit  $n1  $n2  10
  $ns  set  queue-limit  $n2  $n3  5

#Create and attach UDP agent to n0, n1 and null agent to n3.
  set  udp0  [new Agent/UDP]
  $ns  attach-agent  $n0  $udp0

  set  cbr0  [new Application/Traffic/CBR]
  $cbr0  attach-agent  $udp0

  set  udp1  [new Agent/UDP]
  $ns attach-agent $n1 $udp1

  set  cbr1  [new Applicatin/traffic/CBR]
  $cbr1  attach-agent  $udp1

  set  null3  [new Agent/Null]
  $ns  attach-agent  $n3  $null3

#Set udp0 packets to red color and udp1 packets to blue color
  $udp0 set class_1
  $udp1 set class_2

#Connect the agents.
  $ns  connect  $udp0  $null3
  $ns connect $udp1 $null3

  #Set  the  packet  size  to  500
   $cbr1  set  packetSize_ 500Mb

#Set the data rate of the packets. if the data rate is high then packets drops are high 
 $cbr1  set  interval_ 0.005

#Finish Procedure
proc finish  {}  {
global  ns  nf  nt
$ns flush-trace
exec nam lab1.nam &
close $nt
close $nf
exit0
}

$ns at 0.1 "$cbr0 start"
$ns at 0.1 "cbr1 start"
$ns at 10.0 "finish"
$ns run
