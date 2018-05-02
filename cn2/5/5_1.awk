BEGIN{
	count=0;
	time=0;
	printf("%f\t%d",$2,$6);
}
{
	if($1=="r" && $4=="1" && $5=="tcp")
		count += $6;
	printf("\n%f\t%d",$2,count);
}
END{
}

