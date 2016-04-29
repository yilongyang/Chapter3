#read rooted trees and classify markers
use Bio::TreeIO;
use Bio::Tree::Compatible;
use IO::String;
$in="marker-rooted-nwk.txt";
open(IN,"$in");
$out="marker-classify-3.csv";
open(OUT,">>$out");

while(defined($line=<IN>)){
	chomp$line;
	$line=~/(AX.*?)\'/;
	$marker=$1;
	print "$marker\n";
	my $io = IO::String->new($line);
	my $treeio = Bio::TreeIO->new(-fh => $io,
                              -format => 'newick');
	$tree = $treeio->next_tree;
	@nodes=$tree->get_nodes;
	$l=0;
	$smallest="";
	$prenum=8;
	foreach $n(@nodes){
		$l++;
		@desc=$n->get_all_Descendents;
		@lvs=grep{$_ ->is_Leaf}@desc;
		$clade=join(",",sort map {$_->id}@lvs);
		#if($l>-1){
			#print "$l\t$clade<<\n";
		#}
		$num=$clade=~tr/,/,/;
		
		if($l>1 and $clade=~/F|G|P/ and $clade=~/AX/ and $num<$prenum){
			#print "----$clade----\n";
			$smallest=$clade;
			$prenum=$num;
		}	
	}
	#print "Smallest\t$smallest\n";
	
	$AX=0;
	$Fv=0;
	$Fii=0;
	$FRA1358=0;
	$FRA202=0;
	$GS91=0;
	$Potentilla=0;
	# @nodetemp=split(",",$smallest);
	# foreach $tip(@nodetemp){
		# if($tip=~/AX/){
			# $AX=1;
		# }elsif($tip=~/Fv/){
			# $Fv=1;
		# }elsif($tip=~/Fii/){
			# $Fii=1;
		# }elsif($tip=~/FRA1358/){
			# $FRA1358=1;
		# }elsif($tip=~/FRA202/){
			# $FRA202=1;
		# }elsif($tip=~/GS91/){
			# $GS91=1;
		# }elsif($tip=~/Pot/){
			# $Potentilla=1;
		# }
	# }
	# print OUT "$marker,$AX,$Fv,$Fii,$FRA1358,$FRA202,$GS91,$Potentilla\n";
	if($smallest=~/Fv/ and $smallest!~/Fii/){
		print OUT "$marker,YN,$smallest\n";
	}elsif($smallest=~/Fii/ and $smallest!~/Fv/){
		print OUT "$marker,NY,$smallest\n";
	}elsif($smallest!~/Fii/ and $smallest!~/Fv/ and $smallest=~/AX/){
		print OUT "$marker,NN,$smallest\n";		
	}elsif($smallest=~/Fii/ and $smallest=~/Fv/ and $smallest=~/AX/){
		print OUT "$marker,YY,$smallest\n";		
	}	
}
__END__
	
	#while($line=~/\((.*?)\)/g){
	#	print "$1\n";
	#}
	#$line=~/(AX.*?)\)/;
	#print "$1\n";
	#print "\n\n";	
	#$line=~s/\(/=/g;
	#$line=~s/\)/=/g;
	# @temp=split("=",$line);
	# foreach $node(@temp){
		# print ">>$node\n";
	# }
	$rev=reverse($line);
	@fwtemp=split(":",$line);
	@revtemp=split("'",$rev);
	$left=0;
	for($i=0;$i<=scalar@fwtemp;$i++){
		$char=$fwtemp[$i];
		print "C\t$char\n";
	}
}
	
		if($char=~/\(/){
			$left++;
		}
		if($char=~/AX/){
			last;
		}else{
			$head=shift@fwtemp;
			print "$head\n";
		}	
	}
	$right=0;
	for($i=0;$i<scalar@fwtemp;$i++){
		if($right==$left-1){
			last;
		}else{
			$tail=chop@fwtemp;
			if($tail=~/\)/){
				$right++;
			}
		}
		
	}	
	$core=join("",@fwtemp);
	print "CORE\t$core\n";
	
	exit;
}
	