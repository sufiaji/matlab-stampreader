function [x,y] = tempmatching(t,i)
cc = normxcorr2(t,i);
[max_cc, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
x = xpeak - round(size(t,2)/2);
y = ypeak - round(size(t,1)/2);
