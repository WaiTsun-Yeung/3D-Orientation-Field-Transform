function [image1,directi,maxi,sumr,maxr,directr] = orientfield2d(origimage,l1,RAM)

radius = floor(l1/2);
l1 = radius*2+1;
if nargin<3
    RAM = 40*10^9;
end
if RAM<1000
    RAM = RAM*10^9;
end
lines = allstraightlines(l1);
clear allstraightlines;
[r,c,h] = size(origimage);
div = min(h,ceil(r*c*h*length(lines)*6*8/RAM));
hd = ceil(h/div);
directi = zeros(r,c,h);
maxi = zeros(r,c,h);
maxr = zeros(r,c,h);
directr = zeros(r,c,h);
sumr = zeros(r,c,h);
for ii = 0:div-1
    disp([num2str(ii+1) ' of ' num2str(div) ' | ' ...
        datestr(now,'HH:MM:SS.FFF')]);
    [~,...
        directi(:,:,hd*ii+1:min(end,hd*(ii+1))),...
        maxi(:,:,hd*ii+1:min(end,hd*(ii+1))),...
        sumr(:,:,hd*ii+1:min(end,hd*(ii+1))),...
        maxr(:,:,hd*ii+1:min(end,hd*(ii+1))),...
        directr(:,:,hd*ii+1:min(end,hd*(ii+1)))] = ...
        orientfield2dcore(origimage(:,:,hd*ii+1:min(end,hd*(ii+1))),l1,...
        lines,radius);
end
image1 = directr.*maxr.*maxi.*directi.*sumr;
image1 = normalise(image1);