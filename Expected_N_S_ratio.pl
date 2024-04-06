#!perl
my %standard_codon=
		(	TTT=>'F',TTC=>'F',TTA=>'L',TTG=>'L',
			TCT=>'S',TCC=>'S',TCA=>'S',TCG=>'S',
			TAT=>'Y',TAC=>'Y',TAA=>'*',TAG=>'*',
			TGT=>'C',TGC=>'C',TGA=>'*',TGG=>'W',
			CTT=>'L',CTC=>'L',CTA=>'L',CTG=>'L',
			CCT=>'P',CCC=>'P',CCA=>'P',CCG=>'P',
			CAT=>'H',CAC=>'H',CAA=>'Q',CAG=>'Q',
			CGT=>'R',CGC=>'R',CGA=>'R',CGG=>'R',
			ATT=>'I',ATC=>'I',ATA=>'I',ATG=>'M',
			ACT=>'T',ACC=>'T',ACA=>'T',ACG=>'T',
			AAT=>'N',AAC=>'N',AAA=>'K',AAG=>'K',
			AGT=>'S',AGC=>'S',AGA=>'R',AGG=>'R',
			GTT=>'V',GTC=>'V',GTA=>'V',GTG=>'V',
			GCT=>'A',GCC=>'A',GCA=>'A',GCG=>'A',
			GAT=>'D',GAC=>'D',GAA=>'E',GAG=>'E',
			GGT=>'G',GGC=>'G',GGA=>'G',GGG=>'G',
		);
		
%hash1=(A=>G,T=>C,C=>T,G=>A);
%hash2=(A=>C,T=>A,C=>G,G=>T);
%hash3=(A=>T,T=>G,C=>A,G=>C);
%hash4=(AC=>0.11,AG=>0.195,AT=>0.077,CA=>0.286,CG=>0.067,CT=>0.265,
		TG=>0.11,TC=>0.195,TA=>0.077,GT=>0.286,GC=>0.067,GA=>0.265);

#use only data in YPD
#%hash4=(AC=>0.093,AG=>0.221,AT=>0.081,CA=>0.314,CG=>0.093,CT=>0.198,
#		TG=>0.093,TC=>0.221,TA=>0.081,GT=>0.314,GC=>0.093,GA=>0.198);

 $C=0;
 $S=0;
 $N=0;
 $NON=0;

open(FI,"C:/Users/chenp/OneDrive - Umich/Environment250/constant252/18_orf_coding_all_2.fasta");
#open(FI,"C:/Users/chenp/OneDrive - Umich/Environment250/constant252/test");

while($line=<FI>){
 chomp $line;
 $k=0;

 @seq=split/\t/,$line;
 $c = length($seq[1])-3;
 $C=$C+$c;
   while($k < (length($seq[1])-3)){
	
	my $codon=substr($seq[1],$k,3);
	
	 @all=split//,$codon;
	 
    ($codon1 = $codon) =~ s/$all[0](.)(.)/$hash1{$all[0]}$1$2/;
    ($codon2 = $codon) =~ s/$all[0](.)(.)/$hash2{$all[0]}$1$2/;
	($codon3 = $codon) =~ s/$all[0](.)(.)/$hash3{$all[0]}$1$2/;
	($codon4 = $codon) =~ s/(.)$all[1](.)/$1$hash1{$all[1]}$2/;
	($codon5 = $codon) =~ s/(.)$all[1](.)/$1$hash2{$all[1]}$2/;
	($codon6 = $codon) =~ s/(.)$all[1](.)/$1$hash3{$all[1]}$2/;
	($codon7 = $codon) =~ s/(.)(.)$all[2]/$1$2$hash1{$all[2]}/;
	($codon8 = $codon) =~ s/(.)(.)$all[2]/$1$2$hash2{$all[2]}/;
	($codon9 = $codon) =~ s/(.)(.)$all[2]/$1$2$hash3{$all[2]}/;
	
	#print $codon,"\t",$codon1,"\t",$codon2,"\t",$codon3,"\t",$codon4,"\t",$codon5,"\t",$codon6,"\t",$codon7,"\t",$codon8,"\t",$codon9,"\n";

	#print $standard_codon{$codon},"\t",$standard_codon{$codon1},"\t",$standard_codon{$codon2},"\t",$standard_codon{$codon3},"\t",$standard_codon{$codon4},"\t",$standard_codon{$codon5},"\t",$standard_codon{$codon6},"\t",$standard_codon{$codon7},"\t",$standard_codon{$codon8},"\t",$standard_codon{$codon9},"\n";
	
	##########codon1
	if ($standard_codon{$codon} eq $standard_codon{$codon1}){
			$s = $hash4{$all[0].$hash1{$all[0]}};
			$S = $S + $s;
	}elsif($standard_codon{$codon1} eq "*"){
		    $non = $hash4{$all[0].$hash1{$all[0]}};
			$NON = $NON + $non;
	}else{
		    $n=$hash4{$all[0].$hash1{$all[0]}};
			$N = $N + $n;
	}
	#print $codon1,"\t",$S,"\t",$NON,"\t",$N,"\n";	
	
	##########codon2
	if ($standard_codon{$codon} eq $standard_codon{$codon2}){
			$s = $hash4{$all[0].$hash2{$all[0]}};
			$S = $S + $s;
	}elsif($standard_codon{$codon2} eq "*"){
		    $non = $hash4{$all[0].$hash2{$all[0]}};
			$NON = $NON + $non;
	}else{
		    $n=$hash4{$all[0].$hash2{$all[0]}};
			$N = $N + $n;
	}
	#print $codon2,"\t",$S,"\t",$NON,"\t",$N,"\n";	
	
	##########codon3
	if ($standard_codon{$codon} eq $standard_codon{$codon3}){
			$s = $hash4{$all[0].$hash3{$all[0]}};
			$S = $S + $s;
	}elsif($standard_codon{$codon3} eq "*"){
		    $non = $hash4{$all[0].$hash3{$all[0]}};
			$NON = $NON + $non;
	}else{
		    $n=$hash4{$all[0].$hash3{$all[0]}};
			$N = $N + $n;
	}
	#print $codon3,"\t",$S,"\t",$NON,"\t",$N,"\n";	
	
	##########codon4
	if ($standard_codon{$codon} eq $standard_codon{$codon4}){
			$s = $hash4{$all[1].$hash1{$all[1]}};
			$S = $S + $s;
	}elsif($standard_codon{$codon4} eq "*"){
		    $non = $hash4{$all[1].$hash1{$all[1]}};
			$NON = $NON + $non;
	}else{
		    $n=$hash4{$all[1].$hash1{$all[1]}};
			$N = $N + $n;
	}
	#print $codon4,"\t",$S,"\t",$NON,"\t",$N,"\n";	
	
	##########codon5
	if ($standard_codon{$codon} eq $standard_codon{$codon5}){
			$s = $hash4{$all[1].$hash2{$all[1]}};
			$S = $S + $s;
	}elsif($standard_codon{$codon5} eq "*"){
		    $non = $hash4{$all[1].$hash2{$all[1]}};
			$NON = $NON + $non;
	}else{
		    $n=$hash4{$all[1].$hash2{$all[1]}};
			$N = $N + $n;
	}
	#print $codon5,"\t",$S,"\t",$NON,"\t",$N,"\n";	
	
	##########codon6
	if ($standard_codon{$codon} eq $standard_codon{$codon6}){
			$s = $hash4{$all[1].$hash3{$all[1]}};
			$S = $S + $s;
	}elsif($standard_codon{$codon6} eq "*"){
		    $non = $hash4{$all[1].$hash3{$all[1]}};
			$NON = $NON + $non;
	}else{
		    $n=$hash4{$all[1].$hash3{$all[1]}};
			$N = $N + $n;
	}
	#print $codon6,"\t",$S,"\t",$NON,"\t",$N,"\n";	
	
	##########codon7
	if ($standard_codon{$codon} eq $standard_codon{$codon7}){
			$s = $hash4{$all[2].$hash1{$all[2]}};
			$S = $S + $s;
	}elsif($standard_codon{$codon7} eq "*"){
		    $non = $hash4{$all[2].$hash1{$all[2]}};
			$NON = $NON + $non;
	}else{
		    $n=$hash4{$all[2].$hash1{$all[2]}};
			$N = $N + $n;
	}
	#print $codon7,"\t",$S,"\t",$NON,"\t",$N,"\n";	
	
	##########codon8
	if ($standard_codon{$codon} eq $standard_codon{$codon8}){
			$s = $hash4{$all[2].$hash2{$all[2]}};
			$S = $S + $s;
	}elsif($standard_codon{$codon8} eq "*"){
		    $non = $hash4{$all[2].$hash2{$all[2]}};
			$NON = $NON + $non;
	}else{
		    $n=$hash4{$all[2].$hash2{$all[2]}};
			$N = $N + $n;
	}
	#print $codon8,"\t",$S,"\t",$NON,"\t",$N,"\n";	
	
	##########codon9
	if ($standard_codon{$codon} eq $standard_codon{$codon9}){
			$s = $hash4{$all[2].$hash3{$all[2]}};
			$S = $S + $s;
	}elsif($standard_codon{$codon9} eq "*"){
		    $non = $hash4{$all[2].$hash3{$all[2]}};
			$NON = $NON + $non;
	}else{
		    $n=$hash4{$all[2].$hash3{$all[2]}};
			$N = $N + $n;
	}
	#print $codon9,"\t",$S,"\t",$NON,"\t",$N,"\n";	

	$k +=3;
   }
}
		
print $S,"\t",$NON,"\t",$N,"\t",$C,"\n";	

#1009329.47        216965.76        3096843.53       9058617	
#1015297 219585        3073263        9058617
#1003088.4        219629.4        3109792.4 9058617		data only used YPD
 
	
