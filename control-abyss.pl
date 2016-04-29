#control abyss
$in="Marker-reads-LB48.csv";
open(IN,"$in");
$l=0;
while(defined($line=<IN>)){
	chomp$line;
	@temp=split(",",$line);
	$id=shift@temp;
	$leftout="/home/unhTD/yilong/LB48/marker/$id-R1.fastq";
	open(FQ,"$leftout")||next;
	system "abyss-pe name=$id k=16 in='$id-R1.fastq $id-R2.fastq'";
	$l++;
	close FQ;
	#if($l>2){
	#	exit;
	#}	
}
	