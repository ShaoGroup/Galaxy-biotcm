#!/bin/bash
curpath=`pwd`	#save current path

cd  /home/galaxy/galaxy-dist/tools/mytools/drugCIPHER_1.1/view_in
# In view_in, process raw CS.csv 
perl conv.pl ${1}

cd  /home/galaxy/galaxy-dist/tools/mytools/drugCIPHER_1.1/drugCIPHER_model
# In drugCIPHER_model, execute computation
sh drugCIPHER_part_2.sh

cd  /home/galaxy/galaxy-dist/tools/mytools/drugCIPHER_1.1/view_out
# In view_out, compute and output a single drug profile
perl single_gene_format.pl
cp target_profile.txt ${2}

cd  /home/galaxy/galaxy-dist/tools/mytools/drugCIPHER_1.1/drugCIPHER_model/output_data
# In drugCIPHER_model/output_data, output multiple drug profiles
cp profile_rank.txt ${3}
cp profile_rank_druggable.txt ${4}

cd ${curpath}


