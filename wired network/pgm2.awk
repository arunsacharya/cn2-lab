BEGIN {
	tcp_pkts=0;
	total=0;
}
{
	if($5=="tcp" && $1=="r" && $4=="3")
		tcp_pkts+=$6;
		total+=$6;
}
END {
	printf("\nTime=%fms\n",$2);
	printf("Total NO of tcp_packets received=%fMb\n",(total*8/1000000));
	printf("Throughput=%fMbps\n",(total*8/1000000)/$2);
}
