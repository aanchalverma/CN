BEGIN{ pktsSent=0;
pktsRcvd=0;
pktsAtRTR=0; } { if(($1=="s") && ($4=="RTR") &&($7=="tcp")) { pktsAtRTR++;
} if(($1=="s") && ($4=="AGT") && ($7=="tcp"))
{
pktsSent++; } if(($1=="r") && ($4=="AGT") && ($7=="tcp")) { pktsRcvd++;
	} } 
END{ printf("\n Number of Packets sent: "pktsSent); printf("\n NUmber of Packets Recieved: "pktsRcvd); printf("\n Packet Delivery Ratio : "pktsRcvd/pktsSent*100); printf("\n Routing load: "pktsAtRTR/pktsRcvd);
}
