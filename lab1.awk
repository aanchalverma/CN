BEGIN{
count=0;
}
{
	if($1==”d”)
		count++;
}
END{
	printf (“No. of packets dropped is= %d\n”, count);
}
