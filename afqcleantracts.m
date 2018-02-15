function afqcleantracts()
% function afqcleantracts()
% 
% cleans the fiber tracts with AFQ_removeFiberOutliers
%
% DEFAULT maxDist = 4;
% DEFAULT maxLen = 4;
% DEFAULT 100
% DEFAULT maxIter = 5;
%
% Brain Life Team

if ~isdeployed
    switch getenv('ENV')
    case 'IUHPC'
        disp('loading paths (HPC)')
        addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))
        addpath(genpath('/N/u/hayashis/BigRed2/git/afq-master'))
        addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
    case 'VM'
        disp('loading paths (VM)')
        addpath(genpath('/usr/local/jsonlab'))
        addpath(genpath('/usr/local/afq-master'))
        addpath(genpath('/usr/local/vistasoft'))
    end
end

config = loadjson('config.json');
disp('config dump')
disp(config)
load(config.afq_fg);

count    = true;
maxLen   = config.maxlen;
numNodes = config.numnodes;
M        = config.M;
maxDist  = config.maxdist;
maxIter  = config.maxiter;

for ii = 1:length(fg_classified)
    fg_classified_clean(ii) = AFQ_removeFiberOutliers(fg_classified(ii), maxDist, maxLen, numNodes, M, count, maxIter);
end
fg_classified = fg_classified_clean;

save('output.mat', 'fg_classified', 'classification');

%%% 
%% Plotting and visualization code below.
%%
%% Prepare additional parameters for visualization of the results on BL:tract-view
tracts = fg2Array(fg_classified);
mkdir('tracts');

cm = parula(length(tracts));
for it = 1:length(tracts)
   tract.name   = tracts(it).name;
   tract.color  = cm(it,:);

   %pick randomly up to 1000 fibers (pick all if there are less than 1000)
   fiber_count = min(1000, numel(tracts(it).fibers));
   tract.coords = tracts(it).fibers(randperm(fiber_count));

   all_tracts(it).name = tracts(it).name;
   all_tracts(it).color = cm(it,:);
   savejson('', tract, fullfile('tracts',sprintf('%i.json',it)));
   all_tracts(it).filename = sprintf('%i.json',it);
   clear tract
end

savejson('', all_tracts, fullfile('tracts/tracts.json'));
% saving text file with number of fibers per tracts
tract_info = cell(length(fg_classified), 2);

for i = 1:length(fg_classified)
    tract_info{i,1} = fg_classified(i).name;
    tract_info{i,2} = length(fg_classified(i).fibers);
end

T = cell2table(tract_info);
T.Properties.VariableNames = {'Tracts', 'FiberCount'};

writetable(T,'output_fibercounts.txt')

end


