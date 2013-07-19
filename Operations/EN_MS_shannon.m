% EN_MS_shannon
% 
% Calculates the approximate Shannon entropy of a time series using an
% nbin-bin encoding and depth-symbol sequences.
% Uniform population binning is used, and the implementation uses Michael Small's code
% MS_shannon.m (renamed from the original, simply shannon.m)
% cf. M. Small, Applied Nonlinear Time Series Analysis: Applications in Physics,
% Physiology, and Finance (book) World Scientific, Nonlinear Science Series A,
% Vol. 52 (2005)
% Michael Small's code is available at available at http://small.eie.polyu.edu.hk/matlab/
% 
% In this wrapper function, you can evaluate the code at a given n and d, and
% also across a range of depth and nbin to return statistics on how the obtained
% entropies change.
% 
% INPUTS:
% y, the input time series
% nbin, the number of bins to discretize the time series into (i.e., alphabet size)
% depth, the length of strings to analyze

function out = EN_MS_shannon(y,nbin,depth)
% Ben Fulcher, 2009

if nargin < 2 || isempty(nbin)
    nbin = 2; % two bins to discretize the time series, y
end
if nargin < 3 || isempty(depth)
    depth = 3; % three-long strings
end

%% (*) evaluate the shannon entropy for a given set of parameters
if (length(nbin) == 1) && (length(depth) == 1)
    % Run the code, just return a number
    % scales with depth, so it's nice to normalize by this factor:
    out = MS_shannon(y,nbin,depth) / depth;
end

%% (*) Return statistics over depths (constant number of bins)
% Somewhat strange behaviour -- very variable
if (length(nbin) == 1) && (length(depth) > 1)
    % range over depths specified in the vector
    % return statistics on results
    ndepths = length(depth);
    ents = zeros(ndepths,1);
    for i = 1:ndepths
        ents(i) = MS_shannon(y,nbin,depth(i));
    end
    % should scale with depth: normalize by this:
    ents = ents./depth';
    out.maxent = max(ents);
    out.minent = min(ents);
    out.medent = median(ents);
    out.meanent = mean(ents);
    out.stdent = std(ents);
end

%% (*) Statistics over different bin numbers
if (length(nbin) > 1) && (length(depth) == 1)
    % range over depths specified in the vector
    % return statistics on results
    nbins = length(nbin);
    ents = zeros(nbins,1);
    for i = 1:nbins
        ents(i) = MS_shannon(y,nbin(i),depth);
    end
    ents = ents/depth; % should scale with depth: normalize by this:
    out.maxent = max(ents);
    out.minent = min(ents);
    out.medent = median(ents);
    out.meanent = mean(ents);
    out.stdent = std(ents);
end

%% (*) statistics over both nbins and depths
if (length(nbin) > 1) && (length(depth) > 1)
    nbins = length(nbin);
    ndepths = length(depth);
    
    ents = zeros(nbins,ndepths);
    for i = 1:nbins
        for j = 1:ndepths
            ents(i,j) = MS_shannon(y,nbin(i),depth(j))/depth(j);
        end
    end
    % Don't know what quite to do -- I think stick to above, where only one
    % input is a vector at a time.
    % ***INCOMPLETE*** don't do this.
end


end