#define the probe sequences with minor alleles
$in="Markers-on-map.csv";
$out=$in."-probe.fasta";
open(OUT,">>$out");
open(IN, "$in");
while(defined($line=<IN>)){
	chomp$line;
	@temp=split(",",$line);
	$id=$temp[1];
	$allelea=$temp[2];
	$alleleb=$temp[3];
	$aa=$temp[5];
	$bb=$temp[6];
	$seq=$temp[12];
	$probe1=$temp[13];
	$probe2=$temp[14];
	
	if($aa==0){
		$minor=$allelea;
		$major=$alleleb;
	}elsif($bb==0){
		$minor=$alleleb;
		$major=$allelea;
	}
	#print "Minor\t$minor\tMajor\t$major\n";
	$seq=~s/\[$minor\/$major\]/$minor/;
	$seq=~s/\[$major\/$minor\]/$minor/;
	$seq=~s/-//g;
	$minor=~s/-//;
	$minlen=length$minor;
	$reverse1=reverse$probe1;
	$reverse2=reverse$probe2;
	$reverseminor=reverse$minor;
	$reverse1plus=$minor.$reverse1;
	$reverse2plus=$minor.$reverse2;
	
	$cple1=$probe1;
	$cple1=~tr/ATCG/TAGC/;
	$cple2=$probe2;
	$cple2=~tr/ATCG/TAGC/;
	$cpleminor=$minor;
	$cpleminor=~tr/ATCG/TAGC/;
	$cple1plus=$cple1.$minor;
	$cple2plus=$cple2.$minor;
	
	@probes=($cple1plus,$cple2plus,$reverse1plus,$reverse2plus,$cple1,$cple2,$reverse1,$reverse2,$probe1,$probe2);
	#print "\n$id\t$seq\n$probe1\t$probe2\n$probes[0]\n$probes[1]\n$probes[2]\n$probes[3]\n";
	@notes=("1-cple-plus","2-cple-plus","1-rev-plus","2-rev-plus","1-cple","2-cple", "1-rev","2-rev","1","2");
	for($i=0;$i<=scalar@probes;$i++){
		$probe=$probes[$i];
		#print "$notes[$i]\t$probe\n";
		if($seq=~/$probe/ and length$probe>$minlen){
			print OUT ">$id\n$probe\n";
			#print "$notes[$i],$probe,$line\n";
			last;
		}
	}
	#exit;
}

	
	
	
	
	
	
	
	
	
	
	
	
	
	