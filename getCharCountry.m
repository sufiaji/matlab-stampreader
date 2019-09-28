function imgCharArrays = getCharCountry(imOri,uplow)%% initiate global variable

%% BEGIN HERE !!!
h1 = 5; h2 = 7; % for cropping upper/lower part
w1 = 30; % for clipping the border of image
w2 = 50;
%%
% u1 = u2 = = u3 = = u4 = = u5 = u6 = u7 = = u8 = 30
% d1 = d2 = 29
% d3 = = d4 = 27
minNumPixel = 27; % for bwareaopen parameter
%%
% u1 = 0.3          of 0.4902      
% u2 = 0.4          of 0.5490
% u3 = 0.5          of 0.6824
% u4 = 0.5 - 0.9    of 0.5765
% u5 = 0.5 - 0.7    of 0.5765
% u6 = 0.5          of 0.5451
% u7 = 0.7          of 0.6706
% u8 = 0.7 - 0.8    of 0.7255
% d1 = 0.5          of 0.6157
% d2 = 0.2 - 0.7    of 0.7098
% d3 = 0.7          of 0.6392
% d4 = 0.6          of 0.6000
% bwt2 = 0.6; % threshold
%%
% u1 = u2 = u6 = 0.11
% u3 = u4 = 0.09
% u5 = 0.16
% u7 = u8 = d1 = d2 = d3 = d4 = 0.1
dm = 0.1; % max trhershold
% uplow = 'low';
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
clipBorderx = imWidth/w1;
clipBordery = imHeight/w2; % parameter for border clipping
%% crop upper part & lower part
if strcmp(uplow,'up') == 1
    img = imcrop(imOri,[clipBorderx clipBordery imWidth H]);
else
    img = imcrop(imOri,[clipBorderx imHeight-H-clipBordery imWidth H]);
end
%% resize upper part & lower part to 50x300 for consistency
img = imresize(img,[50 300],'nearest');
%% crop price part
wu = round(300*65/100);
img = imcrop(img,[1 1 wu 50]);
%% convert to gray
img = rgb2gray(img);
% figure, imshow(img)
%% find threshold value
bwt = graythresh(img);
%% convert to binary and remove noise
img = im2bw(img,bwt);
img = ~img;
img(size(img,1),1:size(img,2)) = 0;
% img = imclearborder(~img);
img = bwareaopen(img,minNumPixel);
img = imclearborder(img);
% figure, imshow(img)
%% determine which part contain price number based on bounding box area
Stats = regionprops(img,{'BoundingBox'});
%% crop image at each character, save each character image in a cell of array
n = numel(Stats);
imchar = {[]};
% imchar = cell(1,n);
% imchar{1,n} = [];
dimg = double(img);
% find the maximum rextangle of bounding box
rect = [];
for i = 1:n
    rect = Stats(i).BoundingBox;
    rects(i) = rect(3)*rect(4);
end
maxrects = max(rects);
%% return the value
j = 0;
for i = 1:n
    rect = Stats(i).BoundingBox;
    if i > 8
        rect8 = Stats(8).BoundingBox;
        if(abs(rect(1)-rect8(1))>15)
            break;
        end
    end
    if(rect(3)*rect(4)) > dm*max(maxrects)
        j = j+1;
        imchar{1,j} = imcrop(dimg,Stats(i).BoundingBox);
    end
end
%% copy return value to output parameter
imgCharArrays = imchar;
