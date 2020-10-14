function [newimage,lines] = primaryorientationfield(image,lines)
%Generate primary orientation field from 2D or 3D images.
%Cellular tomograms used typically need their colours reverted before
%processing to achieve optimal result.
%This programming code is adapted from this paper:
%Sandberg, K.: Curve enhancement using orientation fields. In Bebis, G.
%(ed.) ISVC 2009, Part 1. LNCS, vol. 5875, pp. 564-575. Springer,
%Heidelberg(2009)
[r,c,h] = size(image);
newimage = zeros(r,c,h,length(lines));
simage = im2single(image);
line = cell2mat(permute(lines(:,1),[2 3 1]));
[l,~,~] = size(line);
line = line./padarray(sum(sum(line,1),2),[l-1 l-1 0],'replicate','post');
for ii = 1:length(lines)
    newimage(:,:,:,ii) = imfilter(simage,line(:,:,ii));
end