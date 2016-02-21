# This file can only generate a detailed target_profile for a single gene
# Watch the required directories

die if !open F1,"../drugCIPHER_model/output_data/profile_rank.txt";
die if !open F2,"../drugCIPHER_model/output_data/raw_target_profile.txt";
die if !open F3,"../drugCIPHER_model/output_data/profile_rank_druggable.txt";
die if !open F4,"symbol_index.txt";
die if !open F5,">target_profile.txt";
$title=<F2>;
while(<F2>){
	chomp;
	@temp=split /\t/,$_;
	$score{$temp[0]}=$temp[1];
}
$title=<F3>;
while(<F3>){
	chomp;
	@temp=split /\t/,$_;
	$druggable{$temp[1]}="druggable";
}
while(<F4>){
	chomp;
	@temp=split /\t/,$_;
	$symbol{$temp[0]}=$temp[1];
}
$title=<F1>;
$rank=1;
print F5 "EntrezID\tGeneSymbol\tScore\tDruggble_rank\n";
while(<F1>){
	chomp;
	@temp=split /\t/,$_;
	print F5 "$temp[1]\t$symbol{$temp[1]}\t$score{$temp[1]}\t";
	if(exists $druggable{$temp[1]}){
		print F5 "$rank\n";
		$rank++;
	}else{
		print F5 "\n";
	}
}
	
