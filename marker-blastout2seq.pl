#read blastoutputs and extract aligned sequences from blast database

$genome="/home/unhTD/yilong/fvesca_v1.1_pseudo.fasta";
open(FH,"$genome")||die;
while(defined($line=<FH>)){
	chomp$line;
	if($line=~/^>LG(\d)/){
		$lg="LG".$1;
	}elsif($line=~/A/){
		$genome{$lg}=$line;
		$len=length$genome{$lg};
		print ">>$lg<<$len\n";
	}
}
	

close FH;	




$aj="markers-unitigs.fa";
open(FH,"$aj")||die;
@seqs=<FH>;
$genomefile=join("",@seqs);
@file=split(">",$genomefile);
shift@file;
$m=0;
foreach $seq(@file){
	@sequence=split("\n",$seq);
	$seqid=shift@sequence;
	$seqs=join("",@sequence);
	$aj{$seqid}=$seqs;
	#print "$seqid\n$aj{$seqid}\n";
	$m++;
	
}
close FH;	
print "Markers\t$m\n";


$in="Marker-unitigs-fvesca-blastout.txt";    ##########################
$sj="Fv";								###########################

open(IN,"$in")||die;
$l=0;
while(defined($line=<IN>)){
	chomp$line;
	#print "$line\n";
	if($line=~/Query/){
		#$seqid=$1;
		$l++;
	}
	if($l>0 and $line=~/^AX/){			#################
		@temp=split("\t",$line);
		$query=$temp[0];
		$hit=$temp[1];
		#print "$hit,$genome{$hit}\n";
		$qstart=$temp[6];
		$qend=$temp[7];
		$out="/home/unhTD/yilong/LB48/tree/$query-aln.fasta";
		open(OUT, ">>$out")||die;
		print OUT ">$query\n$aj{$query}\n";
		print ">$query\n";
		if($temp[8]<$temp[9]){
			$sstart=$temp[8];
			$send=$temp[9];
			$slength=$send-$sstart;
			$sjseq=substr($genome{$hit},$sstart,$slength);
			print OUT ">$sj-$hit-$sstart-$send\n$sjseq\n";
			#print ">$sj-$hit-$sstart-$send\n$sjseq\n";
		}elsif($temp[8]>$temp[9]){
			$sstart=$temp[9];
			$send=$temp[8];
			$slength=$send-$sstart;
			$sjseq=substr($genome{$hit},$sstart,$slength);
			#print OUT "$sstart,$slength,$sjseq\n";
			#
			#print "XX\n";
			$revsj=reverse$sjseq;
			$revsj=~tr/ATCG/TAGC/;
			print OUT ">$sj-$hit-$sstart-$send\n$revsj\n";
			#print ">$sj-$hit-$sstart-$send\n$revsj\n";
		}
		close OUT;
		$l=0;
		#exit;
	}
	
}
	
		
		
		
		
		
		
		
		