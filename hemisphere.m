function ind = hemisphere(radius,threshang)
l = radius*2+1;
span = [false(l,radius,l) [false(radius,1,l);true(radius+1,1,l)]...
    true(l,radius,l)];
span(radius+1,radius+1,1) = false;
span = permute(span,[1 3 2]);
cut = ceil(radius-radius*cos(threshang));
span(:,:,end-cut+1:end) = false;
colind = find(span);
[x,y,z] = ind2sub([l l l],colind);
allind = [x y z].';
allind = allind-radius-1;
surface = abs(sum(allind.^2)-radius^2-0.25)<=radius;
ind = allind(:,surface);