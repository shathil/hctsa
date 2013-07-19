% EN_histent
% 
% Estimates of entropy from the static distribution of the time series. The
% distribution is estimated either using a histogram with nbins bins, or as a
% kernel-smoothed distribution, using the ksdensity function from Matlab's
% Statistics Toolbox with width parameter, w.
% An optional additional parameter can be used to remove a proportion of the
% most extreme positive and negative deviations from the mean as an initial
% pre-processing.
% 
% INPUTS:
% y, the input time series
% historks: 'hist' for histogram, or 'ks' for ksdensity
% nbins: (*) (for 'hist'): an integer, uses a histogram with that many bins (for 'hist')
%        (*) (for 'ks'): a positive real number, for the width parameter for ksdensity
%                        (can also be empty for default width parameter, optimum for Gaussian)
% olremp [opt]: the proportion of outliers at both extremes to remove
%               (e.g., if olremp = 0.01; keeps only the middle 98% of data; 0 keeps all data.
%               This parameter ought to be less than 0.5, which keeps none of the data)
%

function h = EN_histent(y,historks,nbins,olremp)
% Ben Fulcher, August 2009

% Check inputs
if nargin < 2 || isempty(historks)
    historks = 'hist'; % use histogram by default
end
if nargin < 3 % (can be empty for default width for ksdensity)
    nbins = 10; % use 10 bins
end
if nargin < 4
    olremp = 0;
end

% (1) Remove outliers?
if olremp ~= 0
    y = y(y >= quantile(y,olremp) & y <= quantile(y,1-olremp));
    if isempty(y)
        % removed the entire time series?!
        % shouldn't be possible for good values of olremp with equality
        % in the above inequalities
        h = NaN; return
    end
end


% (2) Form the histogram
switch historks
case 'hist' % Use histogram to calculate pdf
    [px, xr] = hist(y,nbins);
    px = px/(sum(px)*(xr(2)-xr(1))); % normalize to a probability density

case 'ks' % Use ksdensity to calculate pdf
    if isempty(nbins)
        [px, xr] = ksdensity(y,'function','pdf'); % selects optimal width
    else
        [px, xr] = ksdensity(y,'width',nbins,'function','pdf'); % uses specified width
    end

otherwise
    error('Unknown distribution method -- specify ''ks'' or ''hist''') % error; must specify 'ks' or 'hist'
end

% plot(xr,px)

% (3) Compute the entropy sum and return it as output
h = -sum(px.*log(eps+px))*(xr(2)-xr(1));

end