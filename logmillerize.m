function [relTimeArray_days,meanValueArray] = logmillerize(timeArray_days,valueArray)
%MILLERIZE Summary of this function goes here
%   Detailed explanation goes here

modTimeArray_days = mod(timeArray_days,1);
relTimeArray_days = unique(modTimeArray_days);
relTimeArray_days = relTimeArray_days(:); % Force array to be a vertical vector

% Preallocate averaged data output array
meanValueArray = zeros(size(relTimeArray_days));

for i1 = 1:numel(relTimeArray_days)
    idx = modTimeArray_days == relTimeArray_days(i1);
    meanValueArray(i1) = exp(mean(log(valueArray(idx))));
end

end

