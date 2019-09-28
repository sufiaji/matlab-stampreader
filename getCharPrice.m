function [imgCharArrays, uplow] = getCharPrice(imOri)%% initiate global variable
h1 = 5; h2 = 7; % for cropping upper/lower part
w1 = 38; % for clipping the border of image
minNumPixel = 25; % for bwareaopen parameter
%% read image and determine it size
% imOri = imread(imgfilename);
imHeight = size(imOri,1);
imWidth = size(imOri,2);
%% determine the cropping parameters based on image height
if imWidth > imHeight
    H = round(imHeight/h1);
else
    H = round(imHeight/h2);
end
clipBorder = imWidth/w1; % parameter for border clipping
%% crop upper part & lower part
imUpper = imcrop(imOri,[clipBorder clipBorder imWidth-2*clipBorder H]);
imLower = imcrop(imOri,[clipBorder imHeight-H-clipBorder imWidth-2*clipBorder H]);
%% resize upper part & lower part to 50x300 for consistency
imUpRes = imresize(imUpper,[50 300],'nearest');
imLoRes = imresize(imLower,[50 300],'nearest');
%% crop price part
wu = round(300*35/100);
imgUpPrice = imcrop(imUpRes,[300-wu 1 wu 50]);
imgLoPrice = imcrop(imLoRes,[300-wu 1 wu 50]);
%% get threshold value for binary conversion 
% >>>>> convert to gray scale image
imGU = rgb2gray(imgUpPrice);
imGL = rgb2gray(imgLoPrice);
% >>>>> get threshold value for binary converting upper part
bwThresh1 = graythresh(imGU);
% bwThresh1 = bwThresh1 - (bwThresh1/(10*bwThresh1/2));
% >>>>> get threshold value for binary converting lower part
bwThresh2 = graythresh(imGL);
% bwThresh2 = bwThresh2 - (bwThresh2/(10*bwThresh2/2));
%% convert to binary, followed by removing noise
imUPBW = im2bw(imGU,bwThresh1);
imLPBW = im2bw(imGL,bwThresh2);
imUPBW = imclearborder(~imUPBW);
imLPBW = imclearborder(~imLPBW);
imUPBW = bwareaopen(imUPBW,minNumPixel);
imLPBW = bwareaopen(imLPBW,minNumPixel);
% imUPBW = bwmorph(imUPBW,'open');
% imUPBW = imerode(imUPBW,strel('square',1));
% figure, imshow(imUPBW);
%% determine which part contain price number based on bounding box area
UStats = regionprops(imUPBW,{'BoundingBox'});
LStats = regionprops(imLPBW,{'BoundingBox'});
% >>>>> bounding box is a properties contain x, y, width and height
% >>>>> and area is width*height, that is box(3)*box(4)
% >>>>> get the area for each bounding box, for upper part
au = zeros(1,numel(UStats));
for i = 1:numel(UStats)
    a = UStats(i).BoundingBox;
    au(i) = a(3)*a(4); % area
end
% >>>>> get the area for each bounding box, for lower part
al = zeros(1,numel(LStats));
for i = 1:numel(LStats)
    b = LStats(i).BoundingBox;
    al(i) = b(3)*b(4); % area
end
%% >>>>> if upper part image is totally black, then the price letter should be on lower part image
% flag for price letter (found = 1, not found = 0)
is_already_determined = 0;
if isempty(au)
    imgPriceBest = imLPBW;
    chars = LStats;
    n = numel(al);
    uplow = 'low';
    is_already_determined = 1;
end
% >>>>> if lower part image is totally black, then the price letter should
% be on lower part image
if isempty(al)
    imgPriceBest = imUPBW;
    chars = UStats;
    n = numel(au);
    uplow = 'up';
    is_already_determined = 1; 
end
% >>>>> if both parts have white area as the candidate of price letter 
% then find which part has the biggest bounding box
if is_already_determined == 0
    mu = max(au);
    ml = max(al);
    if mu > ml
        if numel(au) > 2
            imgPriceBest = imUPBW;
            chars = UStats;
            n = numel(au);
            uplow = 'up';
        else
            imgPriceBest = imLPBW;
            chars = LStats;
            n = numel(al);
            uplow = 'low';
        end
    else
        if numel(al) > 2
            imgPriceBest = imLPBW;
            chars = LStats;
            n = numel(al);
            uplow = 'low';
        else
            imgPriceBest = imUPBW;
            chars = UStats;
            n = numel(au);
            uplow = 'up';
        end
    end
end
%% crop image at each character, save each character image in a cell of array
imchars = cell(1,n);
imchars{1,n} = [];
dimg = double(imgPriceBest);
for i = 1:n
    imchars{1,i} = imcrop(dimg,chars(i).BoundingBox);
end
%% return the value
imgCharArrays = imchars;
