function [m isn ni] = nan20(m)
% nan20.m
% 2011-07-12 by Zhang Li
% Set Matrix with NaN to 0

ni = isnan(m);
isn = ~isempty(find(ni==1));
m(ni)=0;

