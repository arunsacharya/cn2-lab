BEGIN{
	tcp=0;
	total=0;
}
{
	if($5 == "tcp" && $1 == "r")
		tcp+=$6;
	total+=$6;
}
END{
	printf("\nTime = %d",$2);
	printf("\nTotal tcp packets = %d",tcp*8);
	printf("\nTotal packets = %d",total*8);
	printf("\nThroughput = %d",(total*8)/$2); #$2 is time
}
