#Search reads with minor alleles in LB48 sam file
open(FH,"s12864-015-1310-1-s10.csv");
	while(defined($fhline=<FH>)){
		chomp$fhline;
		@temp=split(",",$fhline);
		$id=$temp[0];
		$lg=$temp[3];
		$pos=$temp[4];
		$seq=$temp[10];
		$probe1=$temp[11];
		$probe2=$temp[12];
		$probes{$id}="$lg,$pos,$seq,$probe1,$probe2";
	}
close FH;	
$out="Markers-on-map.csv";
open(OUT, ">>$out");

open(FH,"AxiomGT1.calls_pentaploids1 with parents(NoMinorHom).csv");
	while(defined($fhline=<FH>)){
		chomp$fhline;
		@temp=split(",",$fhline);
		$id=$temp[0];
		$allelea=$temp[7];
		$alleleb=$temp[8];
		$type=$temp[9];
		$aa=$temp[21];
		$bb=$temp[23];
		$hw=$temp[31];
		$lb48=$temp[37];
		$aj=$temp[40];
		
		$probes{$id}="$allelea,$alleleb,$type,$aa,$bb,$hw,$lb48,$aj,".$probes{$id};
	}
close FH;	





open(IN,"Nodes-list.txt");
while(defined($line=<IN>)){
	chomp$line;
	open(ND,"$line");
	while(defined($ndline=<ND>)){
		chomp$ndline;
		@temp=split(",",$ndline);
		$id=$temp[2];
		$node=$temp[3];
		if($id=~/U/){
			$id=~/U(.*?)-(\d)$/;
			$snpid=$1;
		}else{
			$snpid=$id;
		}	
		
		print OUT "$node,$snpid,$probes{$snpid}\n";
	}
	close ND;
}

