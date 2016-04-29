#extract reads with minor alleles from LB48 sam file
$in="Markers-on-map.csv-probe.csv";
open(IN,"$in")||die;
while(defined($line=<IN>)){
	chomp$line;
	@linetemp=split(",",$line);
	$id=$linetemp[3];
	$probe=$linetemp[1];
	$lg=$linetemp[12];
	$pos=$linetemp[13];
	$key="$lg-$pos";
	if(!exists $probes{$key}){
		push(@markers,$key);
		#print "PUSH\t$key\n";
		$probes{$key}=$id;
		$seqs{$id}=$probe;
	}else{
		$probes{$key}=$probes{$key}.",$id";
		$seqs{$id}=$probe;
	}	
	
}
close IN;
print "$markers[0],$markers[1]\n";
$i=0;
$l=0;

open(SAM,"LB48-combined-PE-trimmed-Fv-sorted.bam.bam.sam")||die;
$l++;
$i=0;
while(defined($samline=<SAM>)){
	if($samline!~/^HSQ/){
		next;
	}	
	@samlinetemp=split("\t",$samline);
	$readname=$samlinetemp[0];
	$lg=$samlinetemp[2];
	$start=$samlinetemp[3];
	$seq=$samlinetemp[9];
	
	#print "$lg-$start\n";
	
	
	
	$nextsnp=$markers[$i];
	#print "Nextsnp\t$nextsnp\n";
	@nexttemp=split("-",$nextsnp);
	$nextlg=$nexttemp[0];
	$nextpos=$nexttemp[1];
	$distance=$nextpos-$start;
	$m=0;
	@readexsnp=();
	#print "$lg\t$start\t$nextlg\t$nextpos\n";
	
	if($distance>-1 and $distance < 260 and $lg=~/$nextlg/){
		print "$distance\t$lg\t$nextlg\t$i\tNext snp: $nextsnp\n";
		@ids=split(",",$probes{$nextsnp});
		foreach $id(@ids){
			$probe=$seqs{$id};
			$rev=reverse$probe;
			$cple=$probe;
			$cple=~tr/ATGC/TACG/;
			$revcple=$rev;
			$revcple=~tr/ATGC/TACG/;
			if($seq=~/$probe/){
				$hits{$id}=$hits{$id}.",$readname";
			}elsif($seq=~/$revcple/){
				$hits{$id}=$hits{$id}.",$readname";
			}elsif($seq=~/$rev/){
				$hits{$id}=$hits{$id}.",$readname";
			}elsif($seq=~/$cple/){
				$hits{$id}=$hits{$id}.",$readname";
			}
		}
	}elsif($distance<0 && $lg=~/$nextlg/  ||  $distance>0 && $lg!~/$nextlg/){
		$i++;
		#print "$distance\t$lg\t$nextlg\t$i\tNext snp\n";
	}elsif($lg!~/$nextlg/){
		next;
	}
}
close SAM;
$out="Marker-reads-LB48.csv";
open(OUT,">>$out");
foreach $hit(keys %hits){
	print OUT "$hit,$hits{$hit}\n";
}
	