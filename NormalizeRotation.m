function inew = NormalizeRotation(nfile)
warning off
a = imread(nfile);
ibw = ~im2bw(a);
sizbw = size(ibw);
w = size(a,2);
h = size(a,1);
% figure, imshow(ibw);
%% get the angle of rotation
% find the lowest corner
for i = h:-1:1
    [x,y] = find(ibw(i,:),1,'first');
    if ~isempty(y)
        break;
    end
end
ylowest = i;
xlowest = y;
% find the left corner
index1 = find(ibw,1,'first');
[yleft,xleft] = ind2sub(sizbw,index1);
% find the right corner
index2 = find(ibw,1,'last');
[yright,xright] = ind2sub(sizbw,index2);
% show
% imshow(ibw);
% hold on
% plot(xlowest,ylowest,'*b');
% plot(xleft,yleft,'*r');
% plot(xright,yright,'*g');
% hold off
% get the angle
if((xlowest-xleft)>(xright-xlowest))
    deg = atand((ylowest-yleft)/(xlowest-xleft));
elseif((xlowest-xleft)<(xright-xlowest))
    deg = -atand((ylowest-yright)/(xright-xlowest));
end
% rotate the image with the angle deg degree
ibwrot = imrotate(ibw,round(deg),'bicubic');
irot = imrotate(a,round(deg));
% figure, imshow(ibwrot)
% figure, imshow(irot)
%% begin cropping image
siz = size(ibwrot);
% find the top left corner
topLeftIndex = find(ibwrot,1,'first');
[xtopleft,ytopleft] = ind2sub(siz,topLeftIndex);
% find the bottom right corner
botRightIndex = find(ibwrot,1,'last');
[xbotright,ybotright] = ind2sub(siz,botRightIndex);
% show
% imshow(ibwrot);
% hold on
% plot(ytopleft,xtopleft,'*b');
% plot(ybotright,xbotright,'*g');
% hold off
% crop image
inew = imcrop(irot,[ytopleft xtopleft ybotright-ytopleft xbotright-xtopleft]);
% figure, imshow(inew);
