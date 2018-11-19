#!/usr/bin/perl -w
#Author: Yuli Li
#Date: 
#Modified:
#Description:
#use strict;
use Getopt::Long;

my %opts;
GetOptions(\%opts,"l=s","i=s","o=s");
if (!(defined $opts{l}  and defined $opts{i} and defined $opts{o})) {
		die "************************************************\n
		Options:
		-l CDS-length file
		-i count file
		-o TPM file
		*************************************************\n";
}
my (%h1,%h2,%h3);
open L,"< $opts{l}";
while (my $a=<L>) {
	chomp $a;
	$a=~s/>//;
	if ($a=~/ID/ or $a=~/\#/) {
		next;
	}
	my @itms=split/\t/,$a;
	$h1{$itms[0]}=$itms[1];
}


open I,"< $opts{i}";
open O,"> $opts{o}";
while (my $a=<I>) {
	chomp $a;
	if ($a=~/ID/ or $a=~/\#/) {
		print O "$a\n";
	}
	elsif($a=~/evm/){
		my @itms=split/\t/,$a;
		foreach my $i (1..$#itms) {
			my $rpk=$itms[$i]/$h1{$itms[0]}*1000;
			$h2{$i}{$itms[0]}=$rpk;
			$h3{$i}+=$rpk;
		}
	}
	else{;}
}

#foreach my $m (sort keys %h3) {
	#print "$m\t$h3{$m}\n";
#}

my @samp=keys %h2;

foreach my $k (sort keys %h1) {
	my $TPM;
	foreach my $j (0..$#samp) {
		my $tpm=sprintf("%.2f",$h2{$j+1}{$k}/$h3{$j+1}*1e6);
		$TPM.="$tpm\t";
	}
	chop $TPM;
	print O "$k\t$TPM\n";
}
