#control abyss
$in="Marker-reads-LB48.csv";
open(IN,"$in");
$l=0;
$out="markers-unitigs.fa";
open(OUT, ">>$out");
while(defined($line=<IN>)){
	chomp$line;
	@temp=split(",",$line);
	$id=shift@temp;
	$faout="/home/unhTD/yilong/LB48/marker/$id-unitigs.fa";
	open(FA,"$faout")||next;
	@seqs=<FA>;
	$genomefile=join("",@seqs);
	@file=split(">",$genomefile);	
	shift@file;
	$max=0;
	$maxseq="";
	foreach $seq(@file){
		@sequence=split("\n",$seq);
		$seqid=shift@sequence;
		#print ">>--$seqid<<\n";
		$seqs=join("",@sequence);
		$len=length$seqs;
		if($len > $max or $len==$max){
			$max=$len;
			$maxseq=$seqs;
		}
	}	
	print OUT ">$id\n$maxseq\n";
	close FA;
	#exit;
	#if($l>2){
	#	exit;
	#}	
}
	