#!/bin/bash
module load matlab/2017a

cat > build.m <<END
addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))
addpath(genpath('/N/u/hayashis/BigRed2/git/afq-master'))
addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
mcc -m -R -nodisplay -d compiled afqcleantracts
exit
END
matlab -nodisplay -nosplash -r build
