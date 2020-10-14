function [image,image3d] = orientfield3d(origimage,l1,threshang,RAM)
%Unit of RAM:GB. Default value for threshang: 0. Default value for
%sadthresh: 0.375.
origimage = im2double(origimage);
radius = floor(l1/2);
l1 = radius*2+1;
if nargin<3
    threshang = 0;
end
if threshang>pi
    threshang = threshang/180*pi;
end
if nargin<4
    RAM = 40*10^9;
end
if RAM<1000
    RAM = RAM*10^9;
end
circle1 = strel('disk',1,6);
try
    sphere1 = strel('sphere',1);
    sphere3 = strel('sphere',3);
catch
    sphere1 = strel('ball',1,1);
    sphere3 = strel('ball',3,3);
end
circle3 = strel('disk',3,6);
origimage = imdilate(imerode(origimage,circle1),sphere1);

lines = allstraightlines3(l1,threshang);
[r,c,h] = size(origimage);
div = ceil(sqrt(r*c*h*length(lines)*8*7/RAM));
rd = ceil(r/div);
cd = ceil(c/div);
sum3d = zeros(r,c,h);
for mm = 0:div-1
    for nn = 0:div-1
        cutorigimage = ...
            origimage(max(1,mm*rd-radius):min(end,(mm+1)*rd+radius),...
                max(1,nn*cd-radius):min(end,(nn+1)*cd+radius),:);
        image3d = primaryorientationfield3(cutorigimage,lines);
        image3d = image3d.*l1;
        maxr = max(image3d,[],4);
        sumr = sum(image3d,4);
        sum3dtemp = sumr.*maxr;
        sum3d(max(1,mm*rd):min(end,(mm+1)*rd),...
            max(1,nn*cd):min(end,(nn+1)*cd),:) = ...
            sum3dtemp(radius*(mm~=0)+1:end-radius*(mm~=(div-1)),...
            radius*(nn~=0)+1:end-radius*(nn~=(div-1)),:);
    end
end
image3d = normalise(sum3d);
%image = imopen(imopen(imclose(imclose(image3d,sphere3),circle3),sphere1),...
%    circle1);
image = image3d;
image = laynormalise(image);