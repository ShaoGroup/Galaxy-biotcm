#this program is to convert raw input into acceptable format for drugCIPHER_Part2.m

open F1,$ARGV[0];	#raw input file from PubChem, often as xxx.csv
open REF,"<drug_index_3843.txt";
open F2,">chemical_similarity.txt";
open F3,">recognizable_CIDs.txt";

while(<REF>){
	chomp;
	$druglist[0] = -1;
	push(@druglist,$_);
}
$index = 1;
$is_valid = 0;
while(<F1>){
	chomp;
	@temp=split /,/,$_;
	if(@temp[0]=="CID"){
		$is_valid = 1;
		$head = shift(@temp);
		foreach $temp (@temp){
			print F3 "$temp\n";
		}
		next;
	}
	if($is_valid==0){
		last;
	}
	$cid=shift(@temp);
	if($druglist[$index]==$cid){
		$temp1=join "\t",@temp;
		print F2 "$temp1\n";
		$index++;
		next;
	}else{	#if one drug misses in PubChem compared with Drug_List, fill this line with 0s, and move down to find next drug
		while($druglist[$index]!=$cid){
			@zero=();
			foreach $temp (@temp){
				push(@zero,0)
			}
			$temp1=join "\t",@zero;
			print F2 "$temp1\n";
			$index++;
		}
		$temp1=join "\t",@temp;
		print F2 "$temp1\n";
		$index++;
		next;
	}
}
