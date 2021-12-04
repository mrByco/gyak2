#!/usr/bin/awk -f

{
	nc+=lenght($0)+1
	nw+=NF
}

function add(number,number2)
{
	temp=number+number2
	return temp
}
END {print NR,nw,nc}
