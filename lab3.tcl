set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set tracefile1 [open lab3.tr w]
set winfile [open Winfile w]
$ns trace-all $tracefile1

set namfile [open lab3.nam w]
$ns namtrace-all $namfile 

proc finish {} {
	global ns tracefile1 namfile
	$ns flush-trace
	close $tracefile1
	close $namfile
	exec nam lab3.nam &
	exit  0
}


set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$n1 shape box

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns simplex-link $n2 $n3 0.3Mb 100ms DropTail
$ns simplex-link $n3 $n2 0.3Mb 100ms DropTail

set lan [$ns newLan "$n3 $n4 $n5" 0.5Mb 40ms LL Queue/DropTail MAC/802_3]


$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns simplex-link-op $n2 $n3 orient right
$ns simplex-link-op $n3 $n2 orient left

$ns queue-limit $n2 $n3 20

set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1
$tcp set packet_size_ 552

set ftp [new Application/FTP]
$ftp attach-agent $tcp

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1
$tcp1 set packetSize_ 552
$tcp set fid_ 2

set telnet0 [new Application/Telnet]
$telnet0 attach-agent $tcp1

set outfile1 [open congestion1.xg w]
puts $outfile1 "TitleTest: Congestion Window-- Source _tcp"
puts $outfile1 "XunitTest: Simulation Time(Secs)"
puts $outfile1 "YunitTest: Congestion WindowSize"

set outfile2 [open congestion2.xg w]
puts $outfile2 "TitleTest: Congestion Window-- Source _tcp1"
puts $outfile2 "XunitTest: Simulation Time(Secs)"
puts $outfile2 "YunitTest: Congestion WindowSize"

proc plotWindow {tcpSource outfile} {
	global ns
	set time 0.1
	set now [$ns now]
	set cwnd [$tcpSource set cwnd_]
	puts $outfile "$now $cwnd"
	$ns at [expr $now+$time] "plotWindow $tcpSource $outfile"
}
$ns at 0.1 "plotWindow $tcp $winfile"

$ns at 0.0 "plotWindow $tcp $outfile1"
$ns at 0.1 "plotWindow $tcp1 $outfile2"
$ns at 0.3 "$ftp start"
$ns at 0.5 "$telnet0 start"
$ns at 49.0 "$ftp stop"
$ns at 49.1 "$telnet0 stop"
$ns at 50.0 "finish"

$ns run 

