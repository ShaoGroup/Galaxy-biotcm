#!/bin/bash
# Watch out which format this file is! Is it UNIX?! 
curpath=`pwd`	#save current path

cd /home/galaxy/galaxy-dist/tools/mytools/drugCIPHER_1.1/view_in
# In view_in, process raw CS.csv 
perl conv.pl ${1}

cd /home/galaxy/galaxy-dist/tools/mytools/drugCIPHER_1.1/drugCIPHER_model
# In drugCIPHER_model, execute computation
sh drugCIPHER_part_2.sh

matlab_exec=/usr/local/matlab/bin/matlab
function="drugCIPHER_cluster('/home/galaxy/galaxy-dist/tools/mytools/drugCIPHER_1.1/drugCIPHER_model/output_data/D_G_Profile.mat', ${2})"
echo ${function} > drugCIPHER_cluster_exec.m
${matlab_exec} -nojvm -nodisplay -nosplash < drugCIPHER_cluster_exec.m
rm drugCIPHER_cluster_exec.m
cd /home/galaxy/galaxy-dist/tools/mytools/drugCIPHER_1.1/drugCIPHER_model/output_data
cp class_label.txt ${3}
cp similar_pairs.txt ${4}

cd /home/galaxy/galaxy-dist/tools/mytools/drugCIPHER_1.1/drugCIPHER_model
matlab_exec=/usr/local/matlab/bin/matlab
function="drugCIPHER_cluster('/home/galaxy/galaxy-dist/tools/mytools/drugCIPHER_1.1/drugCIPHER_model/output_data/D_G_Profile_Druggable.mat', ${2})"
echo ${function} > drugCIPHER_cluster_exec.m
${matlab_exec} -nojvm -nodisplay -nosplash < drugCIPHER_cluster_exec.m
rm drugCIPHER_cluster_exec.m
cd /home/galaxy/galaxy-dist/tools/mytools/drugCIPHER_1.1/drugCIPHER_model/output_data
cp class_label.txt ${5}
cp similar_pairs.txt ${6}

cd ${curpath}
