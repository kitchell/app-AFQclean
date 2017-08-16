function fg_clean = AFQ_clean(fg_classified, config)

% cleans the fiber tracts with AFQ_removeFiberOutliers

%maxDist = 4;
maxDist = config.maxdist;

%maxLen = 4;
maxLen = config.maxlen;

%numNodes = 30;
numNodes = config.numnodes;

%M = 'mean';
M = config.M;

%maxIter = 5;
maxIter = config.maxiter;

count = true;

for ii = 1:length(fg_classified)
    fg_clean(ii) = AFQ_removeFiberOutliers(fg_classified(ii), maxDist, maxLen, numNodes, M, count, maxIter);
end

end
