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
	disp('loading paths')
	addpath(genpath('/N/u/hayashis/git/vistasoft'))
	addpath(genpath('/N/u/brlife/git/jsonlab'))
	addpath(genpath('/N/u/brlife/git/afq'))
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

num_tracts = length(fg_classified);
for ii = 1 : num_tracts
    fg_classified_clean(ii) = AFQ_removeFiberOutliers(fg_classified(ii), maxDist, maxLen, numNodes, M, count, maxIter);
end

%%%
%% product.json generation
%%

xs = cell(1, num_tracts);
ys_cleaned = zeros([1, num_tracts]);
ys_resulting = zeros([1, num_tracts]);

% sort cleaned tracts by left/right,
% and count how many within each
% tract were cleaned
for i = 1 : num_tracts
    num_fibers = length(fg_classified(i).fibers);
    num_fibers_cleaned = length(fg_classified_clean(i).fibers);
    amount_cleaned = num_fibers - num_fibers_cleaned;
    
    xs{i} = fg_classified(i).name;
    ys_cleaned(i) = amount_cleaned;
    ys_resulting(i) = num_fibers;
end

bar1 = struct;
bar2 = struct;

bar1.x = xs;
bar1.y = ys_resulting;
bar1.type = 'bar';
bar1.name = 'Resulting Fibers';
bar1.marker = struct;
bar1.marker.color = 'rgb(29,130,209)';

bar2.x = xs;
bar2.y = ys_cleaned;
bar2.type = 'bar';
bar2.name = 'Fibers Cleaned';
bar2.marker = struct;
bar2.marker.color = 'rgb(109,190,249)';

bardata = {bar1, bar2};
barlayout = struct;
barlayout.xaxis = struct;
barlayout.xaxis.tickangle = 90;
barlayout.xaxis.tickfont = struct;
barlayout.xaxis.tickfont.size = 8;

barlayout.barmode = 'stack';
barplot = struct;
barplot.type = 'plotly';
barplot.name = 'Fiber Counts';
barplot.data = bardata;
barplot.layout = barlayout;

product = {barplot};
savejson('brainlife', product, 'product.json');

%% done generating

%%% 
%% Plotting and visualization code below.
%%
%% Prepare additional parameters for visualization of the results on BL:tract-view

fg_classified = fg_classified_clean;

%I need to set -7.3 on r2017a and r2019a..
%Warning: Variable 'fg_classified' was not saved. For variables larger than 2GB use MAT-file version 7.3 or later. 
save('output.mat', 'fg_classified', 'classification', '-v7.3');

tracts = fg2Array(fg_classified);

if ~exist('tracts', 'dir')
    mkdir('tracts');
end

cm = parula(length(tracts));
for it = 1:length(tracts)
   tract.name   = tracts(it).name;
   tract.color  = cm(it,:);

   %pick randomly up to 1000 fibers (pick all if there are less than 1000)
   fiber_count = min(1000, numel(tracts(it).fibers));
   tract.coords = tracts(it).fibers(randperm(fiber_count));
   tract.coords = cellfun(@(x) round(x,2), tract.coords, 'UniformOutput', false);

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


