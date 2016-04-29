#control Mrbayes on Brain
open(IN,"bay-list.txt");
while(defined($line=<IN>)){
	chomp$line;
	$infile="/home/unhTD/yilong/LB48/nxs/".$line;
	system "mb $infile";
}
	