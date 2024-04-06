#perl
# bwa index /scratch/sigbio_project_root/sigbio_project19/piaopiao/Environment/reference/S288C_reference_genome_R64-3-1_20210421/S288C_reference_sequence_R64-3-1_20210421.fa 
# samtools faidx /scratch/sigbio_project_root/sigbio_project19/piaopiao/Environment/reference/S288C_reference_genome_R64-3-1_20210421/S288C_reference_sequence_R64-3-1_20210421.fa
# java -jar /home/piaopiao/picard.jar CreateSequenceDictionary REFERENCE=S288C_reference_sequence_R64-3-1_20210421.fa OUTPUT=S288C_reference_sequence_R64-3-1_20210421.dict

my $dir = "";
opendir (DIR, $dir) or die "can't open the directory!";
@dir = readdir DIR;
$bwa_index = "/../S288C_reference_sequence_R64-3-1_20210421.fa";
$picard = "/../picard.jar";
$GATK = "/../gatk-4.2.2.0/gatk";
$GATK_index = "/../S288C_reference_sequence_R64-3-1_20210421.fa";

foreach $file (@dir) {
    
    if  ($file =~m /env/){
	   #print $file,"\n";
       $newdir = $dir."/".$file;
       opendir (DIR2, $newdir);
	   @dir2 = readdir DIR2;
	   @dir3 = grep /fastq\.gz$/,@dir2;
       my $len = @dir3;
          if ($len == 2){
           print $file,"\n";

#trim_data
system("gunzip -c $newdir/$dir3[0] | fastx_trimmer -Q33 -f 5 -l 145 -z -o $newdir/${dir3[0]}.trimed.gz");
system("gunzip -c $newdir/$dir3[1] | fastx_trimmer -Q33 -f 5 -l 145 -z -o $newdir/${dir3[1]}.trimed.gz");
	   
	   
#bwa2-align;
system("bwa mem -t 1 $bwa_index $newdir/${dir3[0]}.trimed.gz $newdir/${dir3[1]}.trimed.gz > $newdir/$file.bwa.sam");

#samtools sam2bam
system("samtools view -@ 1 -bS -h $newdir/$file.bwa.sam > $newdir/$file.bwa.bam");

#picard sort bam
system("java -Xmx4g -jar $picard SortSam I=$newdir/$file.bwa.bam O=$newdir/$file.bwa.sort.bam SORT_ORDER=coordinate");
system("$samtools/samtools index $newdir/$file.bwa.sort.bam");

#remove duplicates
system("java -Xmx4g -jar $picard MarkDuplicates I=$newdir/$file.bwa.sort.bam O=$newdir/$file.bwa.rmdup.bam METRICS_FILE=$newdir/$file.bwa.txt REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=true ASSUME_SORTED=true");

#add filter
system("samtools view -@ 1 -b -h -f 3 -F 4 -F 8 -F 256 -F 1024 -F 2048 -F 0x100 -q 30 $newdir/$file.bwa.rmdup.bam > $newdir/$file.bwa.filter.bam");
system("samtools index $newdir/$file.bwa.filter.bam");

#add group header
system("java -Xmx4g -jar $picard AddOrReplaceReadGroups I=$newdir/$file.bwa.filter.bam O=$newdir/$file.bwa.filter.head.bam RGPL=illumina RGLB=$newdir/$file RGPU=run RGSM=$newdir/$file CREATE_INDEX=true");
system("samtools index $newdir/$file.bwa.head.bam");


#snp calling
system "java -Xmx4g -jar /home/piaopiao/gatk-4.2.2.0/gatk-package-4.2.2.0-local.jar HaplotypeCaller -R $GATK_index -I $newdir/$file.bwa.head.head.bam -O $newdir/$file.bwa.mutation.vcf";
				
#rm files
system("rm $newdir/${dir3[0]}.trimed.gz");
system("rm $newdir/${dir3[1]}.trimed.gz");
system("rm $newdir/$file.bwa.bam");
system("rm $newdir/$file.bwa.sort.bam");
system("rm $newdir/$file.bwa.rmdup.bam");
system("rm $newdir/$file.bwa.rmdup.bai");
system("rm $newdir/$file.bwa.txt");
system("rm $newdir/$file.bwa.filter.bam");

}
}









