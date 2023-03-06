function [newimage,lines] = primaryorientationfield(image,lines)
%Generate primary orientation field from 2D or 3D images.
%Cellular tomograms used typically need their colours reverted before
%processing to achieve optimal result.
[r,c,h] = size(image);
newimage = zeros(r,c,h,length(lines));
simage = im2single(image);
line = cell2mat(permute(lines(:,1),[2 3 1]));
[l,~,~] = size(line);
line = line./padarray(sum(sum(line,1),2),[l-1 l-1 0],'replicate','post');
l = length(lines);
gauss_sigma = floor(floor(l * 0.5) * 0.5);
gauss_filter ...
    = exp(-(-floor(l * 0.5):floor(l * 0.5)).^2*0.5./(gauss_sigma.^2)) ...
    ./(gauss_sigma*sqrt(2*pi));
gauss_filter = gauss_filter(1:length(lines));
for ii = 1:length(lines)
    newimage(:,:,:,ii) = imfilter(simage,line(:,:,ii));
end
newimage = newimage.*permute(gauss_filter,[1,3,4,2]);