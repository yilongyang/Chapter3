# add MrBayes block to NXS files

open(IN,"/home/unhTD/yilong/LB48/marker-nxs-list.txt");
while(defined($inline=<IN>)){
	chomp$inline;
	$bayout="/home/unhTD/yilong/LB48/nxs/".$inline.".bay";
	open(OUT,">>$bayout");
	$inline="/home/unhTD/yilong/LB48/mafft/".$inline;
	open(XX,"$inline");
	while(defined($xxline=<XX>)){
		chomp$xxline;
		print OUT "$xxline\n";
	}
	close XX;
	$rates= "equal";
	$modelstate="lset applyto = (all) nst=2 rates = $rates;\n";
	print OUT "\nbegin mrbayes;\n";
	print OUT "\tlog start replace;\n";
	print OUT "\tset autoclose = yes nowarn=no;\n";
	print OUT "\t$modelstate";
	print OUT "\tunlink revmat=(all) shape=(all) pinvar=(all) statefreq=(all) tratio= (all);\n";
	print OUT "\tshowmodel;\n";
	print OUT "\tmcmc ngen=100000 printfreq=10000 samplefreq=100 nchains=4 temp=0.2 checkfreq = 100000 diagnfreq = 1000 stopval = 0.01 stoprule = yes nperts = 1; \n";
	print OUT "\tsumt relburnin = yes burninfrac = 0.25 contype = halfcompat;\n";
	print OUT "\tsump relburnin = yes burninfrac =0.25;\n";
	print OUT "\tlog stop;\n";
    print OUT "end;\n";
	
	close OUT;
	#exit;
}
	
 