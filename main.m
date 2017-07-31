function main()

switch getenv('ENV')
case 'IUHPC'
	disp('loading paths (HPC)')
	addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))
	addpath(genpath('/N/u/hayashis/BigRed2/git/afq'))
	addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
case 'VM'
	disp('loading paths (VM)')
	addpath(genpath('/usr/local/jsonlab'))
	addpath(genpath('/usr/local/afq'))
	addpath(genpath('/usr/local/vistasoft'))
end

% load config.json
config = loadjson('config.json');

disp('config dump')
disp(config)

load(config.afq_fg);

fg_classified = AFQ_clean(fg_classified);


save('output.mat', 'fg_classified', 'classification', '-v7.3');
tracts = fg2Array(fg_classified);

mkdir('tracts');

% Make colors for the tracts
cm = parula(length(tracts));
for it = 1:length(tracts)
   tract.name   = tracts(it).name;
   tract.color  = cm(it,:);
   tract.coords = tracts(it).fibers;
   savejson('', tract, fullfile('tracts',sprintf('%i.json',it)));
   clear tract
end

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

