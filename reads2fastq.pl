#extract sequences for target reads

$infastq="/home/unhTD/yilong/LB48/LB48-R1-trimatic-paired_val_1.fq";
open(INFQ,"$infastq");
$l=0;
$m=0;
while(defined($fqline=<INFQ>)){
	chomp$fqline;
	if($fqline=~/^@(HSQ-7.*?)\s+/){
		$seqid=$1;
		$l++;
		$m++;
	}else{
		$leftseq{$seqid}=$leftseq{$seqid}.$fqline."\n";
	
	}
	
}
close INFQ;
print "$infastq\t$l\n";
$infastq="/home/unhTD/yilong/LB48/LB48-R2-trimatic-paired_val_2.fq";
open(INFQ,"$infastq");
$l=0;
$m=0;
while(defined($fqline=<INFQ>)){
	chomp$fqline;
	if($fqline=~/^@(HSQ-7.*?)\s+/){
		$seqid=$1;
		$l++;
		$m++;
		
	}else{
		
		$rightseq{$seqid}=$rightseq{$seqid}.$fqline."\n";
		
	}
	
}
close INFQ;
print "$infastq\t$l\n";

$in="Marker-reads-LB48.csv";
open(IN,"$in");
while(defined($line=<IN>)){
	chomp$line;
	@temp=split(",",$line);
	$id=shift@temp;
	$leftout="/home/unhTD/yilong/LB48/marker/$id-R1.fastq";
	$rightout="/home/unhTD/yilong/LB48/marker/$id-R2.fastq";
	open(LOUT, ">>$leftout");
	open(ROUT,">>$rightout");
	foreach $read(@temp){
		if($read=~/HSQ/){
			print LOUT "@"."$read\n$leftseq{$read}";
			print ROUT "@"."$read\n$rightseq{$read}";
		}	
	}
	close LOUT;
	close ROUT;
}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	