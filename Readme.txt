Phylogenetic analysis of segregation markers
The following is an exploration of the uses of the bioinformatics pipeline to perform phylogenetic analysis of segregation markers as being described in Chapter 3.
1.	Purposes
This pipeline is aiming to perform phylogenetic analysis for each segregate SNP marker individually, in order to provide a genome-wide view of distinction between chromosomes or between subgenome in polyploid organisms.
2.	Required data sets.
1)	Population genotyping data
This pipeline is designed to analysis sequences from a particular chromosome from a polyploid organism, and requires segregation of marker alleles among a population to detect sequences coupled on the same chromosome. For diploids, it is easy to get access to sequences coupled on the same chromosome just by resequencing. So some operations may not be applicable to diploids.
2)	Genome assembly of comparator organisms.
High quality genome assemblies or reference genomes from both in-group and out-group taxa are required to extract homolog sequences to be included in the phylogenetic analysis. For genome assemblies, contig sequences were preferred instead of scaffolds, to avoiding ambiguious ‘N’ nucleotides.
At this time, this pipeline was only designed to analysis the data used in Chapter3. The published version in the future will be suitable for more generic data sets. As an example of how to run this pipelines, analysis performed in Chapter 3 was described in the following:
Step 1. Detection of minor allele
1.	Construction of linkage maps
A pentaploid population of 30 individuals and their parents ‘FvH4’, ‘LB48’, ‘L1’ and ‘BC6’ were genotyped by 4,153 SNP markers on the Affymetrix SNP array. 26 linkage groups (or nodes) were constructed using JoinMap. A list of markers mapped on each linkage group was created for each linkage group. A file containing the absolute path of each linkage group was created and named as "Nodes-list.txt". 
2.	Compile information about a list of markers using ‘Node2marker-infor.pl.pl’
For each marker, the segregating alleles and genotype calls of parents were obtained from the file "AxiomGT1.calls_pentaploids1 with parents (NoMinorHom).csv", which was provided by Affymetrix. The probe sequence(s) for each marker were obtained from the file "s12864-015-1310-1-s10.csv" provided by Affymetrix. These information as well as the mapped positions of each marker obtained from "Nodes-list.txt" were compile into a new file named as "Markers-on-map.csv".
3.	Identification of minor allele using ‘marker2probe-minor.pl’
From the input file of "Markers-on-map.csv", the minor allele was identified as the allele that only present in the heterozygote pentaploid individuals. Then, the minor allele was concatenated to the probe sequence, and they were converted to the strand according to the sequence of the reference genome. The resulted file was named as "Markers-on-map.csv-probe.csv", and the probe sequences were in the second column of that file.
Step 2. Extraction of read pairs matching the minor allele from LB48
1.	Identification of read pairs matching the minor allele from the LB48 SAM file using ‘sam2minor-allele.pl’
First, Illumina sequencing raw reads of LB48 were quality trimmed by Trimmomatics and trim_galore.pl.
Then, filtered reads were mapped to the FvH4 v1.1 reference genome with BWA and samtools, with the final sam file name as "LB48-combined-PE-trimmed-Fv-sorted.bam.bam.sam".
By using the script ‘sam2minor-allele.pl’, read names were output in the file "Marker-reads-LB48.csv". Each row begins with the maker ID, followed by the name of reads.
2.	Extract sequences of match reads using ‘reads2fastq.pl’.
Input files are forward and reverse quality trimmed reads of LB48 named as "/home/unhTD/yilong/LB48/LB48-R1-trimatic-paired_val_1.fq", and "/home/unhTD/yilong/LB48/LB48-R2-trimatic-paired_val_2.fq". The script will output read sequences for each marker in FASTQ format into two files "/home/unhTD/yilong/LB48/marker/$id-R1.fastq" and "/home/unhTD/yilong/LB48/marker/$id-R2.fastq". 
Step 3.  Assemble reads into contigs for each marker
1.	Run the script ‘control-abyss.pl’
From the input file "Marker-reads-LB48.csv", this script gets a list of marker IDs and runs the program ‘abyss-pe’ with the following parameters:
Name=marker_ID
K=16
In=’marker_ID-R1.fastq marker_ID-R2.fastq’   #input FASTAQ files should be in the same folder with this script and "Marker-reads-LB48.csv".
2.	Run the script ‘abyssout2combine.pl’ to collect unitigs from all markers into a single FASTA file
From the input file "Marker-reads-LB48.csv", this script gets a list of marker IDs and then open the ABYSS output file ‘Marker_ID-unitigs.fa’.  The longest sequence from that file was extracted to represent the contig sequence for each marker and write into the output file ‘markers-unitigs.fa’.
Step 4. BLAST
1.	The output file from the previous step ‘markers-unitigs.fa’ was used as query to perform BLAST search in six genomes. Local BLAST was run as shell command as the following:
$ blastn -db /home/unhTD/yilong/Rosbreed/Potentilla_scaffolds.fasta -query markers-unitigs.fa -out Markers-unitigs-Potentilla-blastout.txt -outfmt 7 -evalue 0.1 -num_threads 50

$ blastn -db /home/unhTD/yilong/Project_Yilong_3_Combined/Sample_GS91/GS91-a.lines.fasta -query markers-unitigs.fa -out Markers-unitigs-GS91-blastout.txt -outfmt 7 -evalue 0.05 -num_threads 50

$ blastn -db /home/unhTD/yilong/Project_Yilong_3_Combined/Sample_FRA202/FRA202-a.lines.fasta -query markers-unitigs.fa -out Markers-unitigis-FRA202-blastout.txt -outfmt 7 -evalue 0.05 -num_threads 50

$ blastn -db /home/unhTD/yilong/Project_Yilong_3_Combined/Sample_FRA1358/FRA1358-a.lines.fasta -query markers-unitigs.fa -out Markers-unitigs-FRA1358-blastout.txt -outfmt 7 -evalue 0.05 -num_threads 50


$ blastn -db /home/unhTD/yilong/Fiinumae-PacBio-jelly.out.fasta -query markers-unitigs.fa -out Markers-unitigs-Fii-blastout.txt -outfmt 7 -evalue 0.05 -num_threads 50


$ blastn -db /home/unhTD/yilong/fvesca_v1.1_pseudo.fasta -query markers-unitigs.fa -out Marker-unitigs-fvesca-blastout.txt -outfmt 7 -evalue 0.05 -num_threads 50

2.	Extract homolog sequences
The script ‘marker-blastout2seq.pl’ was used to extract the marker flanking sequence and its best hit of homolog sequences from the FvH4 reference genome into the output file ‘/home/unhTD/yilong/LB48/tree/$query-aln.fasta’ for each marker. Then more best-hit sequences from other five genomes were added into this file by using this script with only changes on the corresponding BLAST output file names and the genome sequence file names.

Step 5. Multiple sequence alignment using MAFFT
1.	By using the script ‘control-mafft.pl’, each file that is corresponding to multiple homolog sequences of a single marker was aligned by using MAFFT Localpair function. The maximum iteration number was set as 1000. The aligned FASTA file was named as "/home/yilong/LB48/tree/$id-aln-mafft.fasta".
2.	Each aligned sequence file was converted to NXS format by using ‘Control-FastaConvert.pl’
This script call the Windows based program ‘FastaConvert.exe’.
Step 6. Phylogenetic analysis
1.	Adding MrBayes commands into the NXS files
By using the script ‘NXS2Mrbayes-2.pl’, the following parameters were added into the NXS files for each marker in order to control the MrBayes analysis.
“begin mrbayes;
	log start replace;
	set autoclose = yes nowarn=no;
	lset applyto = (all) nst=2 rates = equal;
	unlink revmat=(all) shape=(all) pinvar=(all) statefreq=(all) tratio= (all);
	showmodel;
	mcmc ngen=100000 printfreq=10000 samplefreq=100 nchains=4 temp=0.2 checkfreq = 100000 diagnfreq = 1000 stopval = 0.01 stoprule = yes nperts = 1; 
	sumt relburnin = yes burninfrac = 0.25 contype = halfcompat;
	sump relburnin = yes burninfrac =0.25;
	log stop;
end;”
Each revised NXS file was named as ‘Marker_ID-aln-mafft.nxs.bay’.
2.	Running of MrBayes was controlled by ‘control-Mrbayes.pl’.
Input file was the list of BAY files created in the previous step. Phylogenetic trees were stored in TRE files.
3.	Re-rooting of phylogenetic trees by using the script ‘test-1.py’
The input file is a list of TRE files named as "tree-list.txt". This script read each tree and re-root it using the outgroup sequence of Potentilla or FRA1358 or FRA202 or GS91. The re-rooted trees were written into the output file 'marker-rooted-nwk.txt'.
Step 7. Reading the topology of each tree and classify markers
1.	The script ‘tree2classify-160206.pl’ was used to classify markers into subgenome identity categories. The input file is "marker-rooted-nwk.txt". The smallest clade containing the marker flanking sequences were identified based on the following criteria. The smallest clade was defined as an inner clade contains at least two sequences including the marker flanking sequence. Following the naming conversion of subgenome identity categories described in Chapter 2, markers were classified depending on the taxa membership in the smallest clade: YN (sequence from F. vesca instead of F. iinumae was clustered with the flanking sequence), NY (sequence from F. iinumae instead of F. vesca was clustered with the flanking sequence), YY (sequences from both F. vesca and F. iinumae were clustered with the flanking sequence), and NN (neither F. vesca nor F. iinumae sequence(s) was clustered with the flanking sequence). The classification results were written into the output file "marker-classify-3.csv". Then other scripts were used to perform downstream analysis, such as calculation the distribution of each type of marker on each linkage group.
#   C h a p t e r 3  
 