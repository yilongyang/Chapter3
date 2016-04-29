#control MAFFT in Pinky
$in="Marker-reads-LB48.csv";
open(IN,"$in");
$l=0;
$out="markers-unitigs.fa";
open(OUT, ">>$out");
while(defined($line=<IN>)){
	chomp$line;
	@temp=split(",",$line);
	$id=shift@temp;
	$fain="/home/yilong/LB48/tree/$id-aln.fasta";
	open(FA,"$fain")||next;
	close FA;
	$out="/home/yilong/LB48/tree/$id-aln-mafft.fasta";
	system "mafft --localpair --maxiterate 1000 $fain > $out";
}
	