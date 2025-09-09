use strict;

my $seq_tsv_file=shift;
my $out_AA_dist=shift;

sub Seq_entropy
{
	my $seq=shift;
	
	my $base = 20;	#logarithm base
	my @amino_acids = qw (A C D E F G H I K L M N P Q R S T V W Y X);
	my $Legit_AA=join("",@amino_acids);
	my %count_hash=(); # for each amino acid (key) will hold the count in the seq
	$seq=uc($seq);
	my $seq_length=length($seq);
	my @seq=split(//,$seq);
	foreach my $AA (@seq)
	{
		if ($AA eq "*") {
			my @error=("ERROR","Seq contain internal '*'");
			return (\@error);
		}
		if ($Legit_AA !~/$AA/){$AA="X"} # if not legit AA treat it as X
		
		if (exists $count_hash{$AA}) {$count_hash{$AA}++}
		else {$count_hash{$AA}=1};
	}	
	
	
	# based on Gloor MI.pl code
	 
	my @observedAA = sort {$a <=> $b}(keys(%count_hash)); # used to be @key
	my $freq;
	my $entropy;
	my @pos_entropy;
	
	#initiate the header line for the frequency output file
	# my $freq_output = "A\tC\tD\tE\tF\tG\tH\tI\tK\tL\tM\tN\tP\tQ\tR\tS\tT\tV\tW\tY\tX\tentropy\n";
	my @seq_freq_and_entropy=();
	# my $freq_output="";
	#get the counts and entropies for each position
	$entropy = 0;
	foreach my $residue (@amino_acids){	#run thru the residues
		if (exists $count_hash{$residue}){
			$freq = $count_hash{$residue}/$seq_length;
			$entropy += -1 * $freq * (log($freq)/log($base));
			# $freq_output .= "$count_hash{$residue}\t";
			my $freq_formatted=sprintf("%.4f",$freq);
			push(@seq_freq_and_entropy,$freq_formatted);
		}else{
			# $freq_output .= "0\t";
			push(@seq_freq_and_entropy,0);
		}
	}
	#create a hash of entropies keyed to the positions in the MSA
	# $freq_output .= "\t$entropy\t$seq_length\n";
	push(@seq_freq_and_entropy,(sprintf("%.4f",$entropy),$seq_length));
	# print "$seq\n$freq_output";	
	return (\@seq_freq_and_entropy);
}

# my $seq="AAAAAAAAAAAAAAAAAATTTTTTTTTTTTTTTTTXXXXXXXXXXXXX";
# my $seq="ACDEFGHIKLMNPQRSTVWY";

open (my $IN,"<",$seq_tsv_file) || die "Can't open IN '$seq_tsv_file' $!";
open (my $OUT,">",$out_AA_dist) || die "Can't open OUT '$out_AA_dist' $!";
print $OUT  "seq_id\tDB_label\tA\tC\tD\tE\tF\tG\tH\tI\tK\tL\tM\tN\tP\tQ\tR\tS\tT\tV\tW\tY\tX\tentropy\tlength\n";
while (my $line=<$IN>)
{
	chomp ($line);
	my ($seq_id,$seq,$length,$DB_label)=split(/\s+/,$line);

	# figure out the DB_label
	if (!defined $DB_label)
	{
		($DB_label)=split(/_/,$seq_id);
		if ($DB_label eq "Environmental")
        	{
           		my @tmp=split(/_/,$seq_id);
           		$DB_label=join("_",@tmp[0..3]);
        	}
        	if ($DB_label=~/^NOV/)
        	{
           		$DB_label=substr($DB_label,0,3);
        	}
        	if ($DB_label=~/^MGVV/)
        	{
           		$DB_label=substr($DB_label,0,3);
        	}
	}
	
	if ($seq=~/\*$/){$seq=~s/\*+$//g;
		print STDERR "[INFO] '*' character(s) were removed from the end of sequnece '$seq_id'\n";
	}
	if ($seq=~/\^*/){$seq=~s/\^*+//g;
		print STDERR "[INFO] '*' character(s) were removed from the begining of sequnece '$seq_id'\n";
	}
	my ($entropy_and_freq_ArrRef)=Seq_entropy($seq);
	
	if ($entropy_and_freq_ArrRef->[0] eq "ERROR")
	{
		print STDERR "[WARNING] Skipping sequence '$seq_id' -> ",$entropy_and_freq_ArrRef->[1],"\n";
	} else {
		print $OUT join("\t",($seq_id,$DB_label,@{$entropy_and_freq_ArrRef})),"\n";
	} 
}
close ($IN);
close ($OUT);

