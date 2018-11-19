my $sample1=3;
my $sample2=3;
my $RC_cut=3;
my $sample_rate=0.4;

print "\n    Designed for make edgeR input RC file from toal RC file, only for 2 group data with geneID\n\n";


parse_command_line();

$sample_total=$sample1+$sample2;
$sample_cut1=$sample1*$sample_rate;
$sample_cut2=$sample2*$sample_rate;

opendir (DIR,"$input");
@dire=readdir DIR;
foreach $file (@dire){
   if($file eq "."||$file eq ".."){;}
   else{
      open FIG,"<./$input/$file";
	  open OUT,">./$input/filter_$file";
	  while(<FIG>){
	     chomp;
		 $case=$control=0;
		 @_=split(/\s+/);
		 for($i=1;$i<1+$sample1;$i++){
		    if($_[$i]>=$RC_cut){$case++;}
		 }
		 for($i=1+$sample1;$i<1+$sample_total;$i++){
		    if($_[$i]>=$RC_cut){$control++;}
		 }
		 if($case>=$sample_cut1||$control>=$sample_cut2){print OUT "$_\n";}
	  }
	  close FIG;
	  close OUT;
   }
}


sub parse_command_line {
    if(!@ARGV){usage();} 
    while (@ARGV) {
	$_ = shift @ARGV;
	if       ($_=~/^-i$/)    { $input = shift @ARGV; }
	    elsif($_=~/^-N1$/)  { $sample1 = shift @ARGV; }
		elsif($_=~/^-N2$/)  { $sample2 = shift @ARGV; }
        elsif ($_=~/^-RC$/) { $RC_cut= shift @ARGV; }
        elsif ($_=~/^-NC$/) { $sample_rate= shift @ARGV; }
	else               {
               print STDERR "Unknown command line option: '$_'\n";
	       usage();
	}
    }
}

sub usage {
    print STDERR <<EOQ; 
    input file should put in a directory named "data", the output file will also be placed in the directory with a Prefix "filter" ^.^
    Usage:
    perl filter_RC.pl -i -N1 -N2 -RC -NC [-h]
	i  :input directory
    N1  :num of sample per group1                                                            [3]
	N2  :num of sample per group2                                                            [3]
    RC :minimum Raw Count for a gene to define a gene is expressed in a sample             [3]
    NC :minimum rate for a group to define a gene is widly expressed in a group            [0.6]
    if a gene is widly expressed in group1 or group2, the gene will be retained in the output file for further analysis, or it will be discarded.
	
    @@---------------------------------------------------------------------------------------@
    |                              format of input RC file  
    | geneID   1_1    1_2   1_3   2_1    2_2    2_3 
    | gene1	    1      1     1     2      2      2  
    | gene2	    2      4     3     40     45     46   
    @@---------------------------------------------------------------------------------------@

EOQ
exit(0);
}
