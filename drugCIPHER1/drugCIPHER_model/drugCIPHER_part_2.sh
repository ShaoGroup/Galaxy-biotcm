# Watch out which format this file is! Is it UNIX?! 
matlab_exec=/usr/local/matlab/bin/matlab
function="drugCIPHER_part_2('../view_in/chemical_similarity.txt')"
echo ${function} > drugCIPHER_part_2_exec.m
${matlab_exec} -nojvm -nodisplay -nosplash < drugCIPHER_part_2_exec.m
rm drugCIPHER_part_2_exec.m