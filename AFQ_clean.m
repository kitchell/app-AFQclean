function fg_clean = AFQ_clean(fg_classified, config)

% cleans the fiber tracts with AFQ_removeFiberOutliers

% DEFAULT maxDist = 4;
maxDist = config.maxdist;

% DEFAULT maxLen = 4;
maxLen = config.maxlen;

% DEFAULT 100
numNodes = config.numnodes;

M = config.M;

% DEFAULT maxIter = 5;
maxIter = config.maxiter;

count = true;

for ii = 1:length(fg_classified)
    fg_clean(ii) = AFQ_removeFiberOutliers(fg_classified(ii), maxDist, maxLen, numNodes, M, count, maxIter);
end

end
