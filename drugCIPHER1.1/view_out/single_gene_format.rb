header = File.open("/home/galaxy/galaxy-dist/tools/mytools/drugCIPHER_1.1/drugCIPHER_model/output_data/profile_rank.txt").readline
puts header
index = header.chomp.split(/\t/)
index.shift
index.each_with_index do |e, i|
	system "perl single_gene_format_test.pl #{e} #{(i+1).to_s}"
end

system "rm target_profile_package.zip"
zip_cmd = "zip target_profile_package.zip"
index.each do |e|
	zip_cmd += " #{e.to_s}_target_profile.txt"
end
system zip_cmd

rm_cmd = "rm"
index.each do |e|
	rm_cmd += " #{e.to_s}_target_profile.txt"
end
system rm_cmd

	
