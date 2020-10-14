function output = comparetome(tome1,tome2,tome3)
[r,c,h] = size(tome1);
tome1 = permute(im2double(tome1),[1 2 4 3]);
tome2 = permute(im2double(tome2),[1 2 4 3]);

if nargin == 2
    output = zeros(r*2,c*2,3,h);
    output(1:r,1:c,1,:) = tome1;
    output(1:r,1:c,2,:) = tome2;
    output(1:r,c+1:end,:,:) = padarray(tome1,[0 0 1 0],'replicate');
    output(r+1:end,1:c,:,:) = padarray(tome2,[0 0 1 0],'replicate');
else
    tome3 = permute(im2double(tome3),[1 2 4 3]);
    output = zeros(r*2,c*3,3,h);
    output(1:r,1:c,:,:) = padarray(tome1,[0 0 1 0],'replicate');
    output(r+1:end,c+1:c*2,:,:) = padarray(tome2,[0 0 1 0],'replicate');
    output(1:r,c*2+1:end,:,:) = padarray(tome3,[0 0 1 0],'replicate');
    output(1:r,c+1:c*2,1,:) = tome1;
    output(1:r,c+1:c*2,2,:) = tome2;
    output(1:r,c+1:c*2,3,:) = tome3;
end
if nargout<1
    implay(output);
end