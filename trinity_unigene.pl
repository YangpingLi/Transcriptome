parse_command_line();

open IN,"<$input";
open OUT,">$input"."_out";
$cnt=0;
while(<IN>){
            chomp;
            $cnt++;
            if($_=~/>/){ 
                        @_=split(/_|\s|=/);
                        if($cnt==1){$comp=$_[0];$c=$_[1];$len=$_[4];$name=$_;$jud=1;}
                        elsif($_[0] eq $comp && $_[1] eq $c){
                                    if($len<$_[4]){@word=();$name=$_;$jud=1;$len=$_[4];}
                                    else{$jud=0;}
                        }
                        else{
                             print OUT "$name\n";
                             for $1 (@word){print OUT "$1\n";}
                             @word=();$comp=$_[0];$c=$_[1];$len=$_[4];$name=$_;$jud=1;   
                        }
            }
            else{
                 if($jud){push (@word,$_);}
                 else{;}
            }
}
print OUT "$name\n";
foreach $1 (@word){print OUT "$1\n";}

sub parse_command_line {
  if(!@ARGV){usage();}
  else{
    while (@ARGV) {
	           $_ = shift @ARGV;
                   if ($_ =~ /^-i$/) { $input   = shift @ARGV; }
	           else {
	                 usage();
	           }
    }
  }
}    

sub usage {
    print STDERR <<EOQ; 
    perl trinity_unigene.pl -i [-h]   
    i  :input file 
    h  :display the help information.
EOQ
exit(0);
}           
