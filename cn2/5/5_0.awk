BEGIN{
	sent = 0;
	recv = 0;
}
{
	if($1=="r" && $4==1 && $5=="tcp")
		recv += $6;
	if($1=="+" && $3==0 && $5=="tcp")
		sent += $6;
}
END{
	printf("\nNo. of bytes sent: %d",sent);
	printf("\nNo. of bytes recv: %d\n\n",recv);
}
		
