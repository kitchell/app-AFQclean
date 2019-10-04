#!/bin/bash
#module load matlab/2017a
module load matlab/2019a

log=compiled/commit_ids.txt
true > $log
echo "/N/u/hayashis/git/vistasoft" >> $log
(cd /N/u/hayashis/git/vistasoft && git log -1) >> $log
echo "/N/u/brlife/git/jsonlab" >> $log
(cd /N/u/brlife/git/jsonlab && git log -1) >> $log
echo "/N/u/brlife/git/afq" >> $log
(cd /N/u/brlife/git/afq && git log -1) >> $log

cat > build.m <<END
addpath(genpath('/N/u/brlife/git/jsonlab'))
addpath(genpath('/N/u/brlife/git/afq'))
addpath(genpath('/N/u/hayashis/git/vistasoft'))

mcc -m -R -nodisplay -d compiled afqcleantracts
exit
END
matlab -nodisplay -nosplash -r build && rm build.m
