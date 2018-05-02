BEGIN{
	tcp_count =0;
	udp_count =0;
	tcp_drop =0;
	udp_drop =0;
}
{
	if($1 == "d" && $5 =="cbr")
		udp_count++;
	if($1 == "d" && $5 =="tcp")
		tcp_count++;
	if($1 == "r" && $5 =="cbr")
		udp_drop++;
	if($1 == "r" && $5 == "tcp")
		tcp_drop++;
}
END{
	printf("\n UDP packets dropped = %d",udp_drop);
	printf("\n UDP packets delivered = %d",udp_count);
	printf("\n TCP packets dropped = %d",tcp_drop);
	printf("\n TCP packets delivered = %d\n\n",tcp_count);
}

