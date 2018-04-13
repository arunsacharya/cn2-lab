BEGIN {
	tcp_count1=0;
	tcp_count2=0;
	udp_count1=0;
	udp_count2=0;
}
{
	if($1=="r" && $5=="tcp")
		tcp_count1++;
	if($1=="d" && $5=="tcp")
		tcp_count2++;
	if($1=="r" && $5=="cbr")
		udp_count1++;
	if($1=="d" && $5=="cbr")
		udp_count2++;
}
END {
	printf("TCP packets received is %d\n",tcp_count1);
	printf("TCP packets dropped is %d\n",tcp_count2);
	printf("UDP packets received is %d\n",udp_count1);
	printf("UDP packets dropped is %d\n",udp_count2);
}
