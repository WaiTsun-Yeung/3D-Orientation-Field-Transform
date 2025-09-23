function [image,image3d] = orientfield3d_with_components(origimage,l1,threshang,RAM)
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
        directr = std(image3d,1,4);
        [image,indices] = max(image3d,[],4);
        ang = cell2mat(lines(:,2));
        [r,c,h] = size(image);
        angimage = reshape(ang(indices(:), :),r,c,h,1,3);
%         angimage = permute(ang(indices, :), [3, 4, 5, 1, 2]);
        % The direction here is a 3D unit vector, not an angle, so can't
        % copy directly from orientfield2dcore.m
        align = zeros(r,c,h,length(ang));
        for ii = 1:length(ang)
            line = lines{ii,1};
            [rind,cind,hind] = ind2sub(size(line),find(line));
            wtemp = zeros(r+l1-1,c+l1-1,h+l1-1,length(rind));
            angtemp = zeros(r+l1-1,c+l1-1,h+l1-1,length(rind),3); 
            gauss_sigma = floor(floor(length(rind) * 0.5) * 0.5);
            gauss_filter ...
                = exp(-(-floor(length(rind)*0.5):floor(length(rind)*0.5)).^2*0.5./(gauss_sigma.^2)) ...
                ./(gauss_sigma*sqrt(2*pi));
            for jj = 1:length(rind)
                wtemp(rind(jj):rind(jj)+r-1,cind(jj):cind(jj)+c-1,...
                    hind(jj):hind(jj)+h-1,jj) = image*gauss_filter(jj);
                angtemp(...
                    rind(jj):rind(jj)+r-1,cind(jj):cind(jj)+c-1,...
                    hind(jj):hind(jj)+h-1,jj,:) = angimage; %Needs to be changed to vector.
            end
            wtemp ...
                = wtemp(...
                    radius+1:end-radius,radius+1:end-radius,...
                    radius+1:end-radius,:);
            angtemp ...
                = angtemp(...
                    radius+1:end-radius,radius+1:end-radius,...
                    radius+1:end-radius,:,:);
            angtemp ...
                = 2*(sum(angtemp.*permute(ang(ii, :),[3,4,5,1,2]),5)).^2 ...
            -1;
            % angtemp = cos(2.*(angtemp-ang(ii)));
            align(:,:,:,ii) = sum(wtemp.*angtemp,4);
        end
        sumi = sum(align,4);
        directi = std(align,1,4);
        maxi = max(align,[],4);
        maxr = normalise(maxr);
        sumr = normalise(sumr);
        directr = normalise(directr);
        sumi = normalise(sumi);
        directi = normalise(directi);
        maxi = normalise(maxi);
        save orientfield3dcoredump.mat maxr sumr directr maxi sumi directi
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