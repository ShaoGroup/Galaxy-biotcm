function drugCIPHER_cluster(Input_File, threshold, Output_File_1, Output_File_2)
	tic;
	if nargin==2
		Output_File_1='./output_data/class_label.txt';
		Output_File_2='./output_data/similar_pairs.txt';
	end
	target_profile = importdata(Input_File);
	dist = pdist(target_profile, 'cosine');
	result = linkage(dist, 'complete');
	class_label = cluster(result, 'cutoff', threshold, 'criterion', 'distance');
	dlmwrite(Output_File_1, class_label, '\t');
	
	dist_square = squareform(dist);
    [index_x, index_y] = find(dist_square < threshold);
    similar_pairs = [];
    for i = 1:length(index_x)
        if index_x(i) < index_y(i) 
            similar_pairs = [similar_pairs; [index_x(i), index_y(i), dist_square(index_x(i), index_y(i))]];
        end
    end
    dlmwrite(Output_File_2, similar_pairs, '\t');
	toc;
end
