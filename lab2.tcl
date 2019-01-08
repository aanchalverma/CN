#create a simulator object
set ns [new Simulator]
#open a nam trace file
set nf [open PING.nam w]
$ns namtrace-all $nf
set nt [open PING.tr w]
$ns trace-all $nt
#define a finsish procedure
proc finish { } {
	global ns nf nt
	$ns flush-trace
	close $nf
	close $nt
	exec nam PING.nam &
	exit 0
}
#create six nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
#connect the nodes with two links
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n2 $n1 1Mb 10ms DropTail
$ns duplex-link $n3 $n1 1Mb 10ms DropTail
$ns duplex-link $n4 $n1 1Mb 10ms DropTail
$ns duplex-link $n5 $n1 1Mb 10ms DropTail
# set queue length
$ns queue-limit $n0 $n1 5
$ns queue-limit $n2 $n1 2
$ns queue-limit $n3 $n1 5
$ns queue-limit $n4 $n1 2
$ns queue-limit $n5 $n1 2
# label the nodes
$n0 label "ping0"
$n1 label "Router"
$n2 label "ping2"
$n3 label "ping3"
$n4 label "ping4"
$n5 label "ping5"

$ns color 2 blue
$ns color 3 red
$ns color 4 yellow
$ns color 5 green

#define a 'recv' function for the class 'Agent/Ping'

Agent/Ping instproc recv {from rtt} {
	$self instvar node_
	puts "node [$node_ id] received ping answer from\
	$from with round-trip-time $rtt ms"
}
#create ping agents and attch then to the nodes

set p0 [new Agent/Ping]
$ns attach-agent $n0 $p0
	$p0 set class_ 1
	set p2 [new Agent/Ping]
$ns attach-agent $n2 $p2
	$p2 set class_ 2
set p3 [new Agent/Ping]
$ns attach-agent $n3 $p3
$p3 set class_ 3

set p4 [new Agent/Ping]
$ns attach-agent $n4 $p4
$p4 set class_ 4
set p5 [new Agent/Ping]
$ns attach-agent $n5 $p5
$p4 set class_ 5

#connect he two agents
$ns connect $p2 $p5
$ns connect $p3 $p5

proc SendPingPacket { } {
	global ns p2 p3
	set intervalTime 0.001
	set now [$ns now]
	$ns at [expr $now+$intervalTime] "$p2 send"
	$ns at [expr $now+$intervalTime] "$p3 send"
	$ns at [expr $now+$intervalTime] "SendPingPacket"
}
$ns at 0.1 "SendPingPacket"
$ns at 2.0 "finish"
$ns run
