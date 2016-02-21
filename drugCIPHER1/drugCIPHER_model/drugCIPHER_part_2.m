function drugCIPHER_Part2(Input_File,Output_File_1,Output_File_2,Output_File_3)

tic;

if nargin==1
	Output_File_1='./output_data/raw_target_profile.txt';
	Output_File_2='./output_data/profile_rank.txt';
	Output_File_3='./output_data/profile_rank_druggable.txt';
end

% Drug_Similarity_Matrix: New CID to Drug Seeds Chemical Similarity
% Drug_Similarity_Matrix_Scale  : The Square Scale on Chemical Similarity
% Gene2Drug_Closeness           : Gene Closeness to Drug;
% PPI_Index                     : Gene Index in PPI network;
% File_Name                     : The output file name

Drug_Similarity_Matrix_Path = Input_File;
Gene2Drug_Closeness_Path = './model_data/Gene2Drug_Closeness.mat';
PPI_Index_Path = './model_data/PPI_Index.txt';
Druggable_List_Path = './model_data/Druggable_Genes_PPI.txt';

% !!! This path is outside the model folder 
% !!! Watch out when you change the model
Input_CID_Path = '../view_in/recognizable_CIDs.txt';

Drug_Similarity_Matrix_Scale = 8;

load(Gene2Drug_Closeness_Path);
PPI_Index = load(PPI_Index_Path);
Drug_Similarity_Matrix = load(Drug_Similarity_Matrix_Path);
Drug_Similarity_Matrix = Drug_Similarity_Matrix./100;	%Input similarity score are supposed to be 0 to 100;
Druggable_List = load(Druggable_List_Path);


%% compute target profile matrix
[temp1,DrugNum]	= size(Drug_Similarity_Matrix);
[GeneNum,temp2] = size(Gene2Drug_Closeness);
Drug2Gene_Closeness = Gene2Drug_Closeness';
clear Gene2Drug_Closeness;
D_G_Profile = zeros(DrugNum,GeneNum);
for	i = 1:DrugNum
	D_G_Profile(i,:) = corr(Drug_Similarity_Matrix(:,i).^Drug_Similarity_Matrix_Scale,Drug2Gene_Closeness);
	if rem(i,10)==0
		fprintf('computing the %dth drug...\n',i);
	end
end
D_G_Profile(isnan(D_G_Profile)) = 0;


%% process matrix to get raw_target_profile.txt
fid = fopen(Output_File_1,'w');
fid_1 = fopen(Input_CID_Path,'r');

while ~feof(fid_1)	%add the first line that means to which CID a target profile belong
	s=fgetl(fid_1);
	if ~strcmp(s,'CID')
		fprintf(fid,'\t%s',s);
	end
end
fprintf(fid,'\n');

for i = 1:GeneNum
	%fprintf('outputing the %dth gene...\n',i);
    fprintf(fid,'%d',PPI_Index(i));
    for j = 1:DrugNum
        fprintf(fid,'\t%f',D_G_Profile(j,i));
    end
    fprintf(fid,'\n');
end
fclose(fid);
fclose(fid_1);


%% process matrix to get profile_rank.txt
D_G_Profile_Rank = zeros(DrugNum,GeneNum);
for i = 1:DrugNum
	[temp3,D_G_Profile_Rank(i,:)]=sort(D_G_Profile(i,:),'descend');
end

fid = fopen(Output_File_2,'w');
fid_1 = fopen(Input_CID_Path,'r');
while ~feof(fid_1)	%add the first line that means to which CID a target profile belong
	s=fgetl(fid_1);
	if ~strcmp(s,'CID')
		fprintf(fid,'\t%s',s);
	end
end
fprintf(fid,'\n');

for i = 1:GeneNum
	%fprintf('outputing the %dth gene...\n',i);
    fprintf(fid,'%d',i);
    for j = 1:DrugNum
        fprintf(fid,'\t%d',PPI_Index(D_G_Profile_Rank(j,i)));
    end
    fprintf(fid,'\n');
end
fclose(fid);
fclose(fid_1);


%% process matrix to get profile_rank_druggable.txt
DruggableGeneNum = length(Druggable_List);
D_G_Profile_Druggable = zeros(DrugNum,DruggableGeneNum);
for i = 1:DruggableGeneNum
	temp4 = find(PPI_Index==Druggable_List(i));
	D_G_Profile_Druggable(:,i) = D_G_Profile(:,temp4);
end

D_G_Profile_Druggable_Rank = zeros(DrugNum,DruggableGeneNum);
for i = 1:DrugNum
	[temp5,D_G_Profile_Druggable_Rank(i,:)]=sort(D_G_Profile_Druggable(i,:),'descend');
end
	
fid = fopen(Output_File_3,'w');
fid_1 = fopen(Input_CID_Path,'r');
while ~feof(fid_1)	%add the first line that means to which CID a target profile belong
	s=fgetl(fid_1);
	if ~strcmp(s,'CID')
		fprintf(fid,'\t%s',s);
	end
end
fprintf(fid,'\n');

for i = 1:DruggableGeneNum
	%fprintf('outputing the %dth gene...\n',i);
    fprintf(fid,'%d',i);
    for j = 1:DrugNum
        fprintf(fid,'\t%d',Druggable_List(D_G_Profile_Druggable_Rank(j,i)));
    end
    fprintf(fid,'\n');
end
fclose(fid);
fclose(fid_1);

sss = size(D_G_Profile);
fprintf('%d---%d\n', sss(1), sss(2));
save('./output_data/D_G_Profile.mat', 'D_G_Profile');
save('./output_data/D_G_Profile_Druggable.mat', 'D_G_Profile_Druggable');

fprintf('%d---%d\n', sss(1), sss(2));
toc;



