function [lines] = allstraightlines3(l,threshang)
%ALLSTRAIGHTLINES3 Compute 3D line structural elements of all angles with
%the given length l.
%The value l will be rounded to the nearest odd number for simplicity.
if nargin<2
    threshang = pi/6;
end
if threshang>pi
    threshang = threshang/180*pi;
end
trueradius = floor(l/2);
truel = trueradius*2+1;
ind = hemisphere(trueradius,threshang);

ind2 = ind+trueradius+1;
ind1 = -ind+trueradius+1;
ind1x = ind1(1,:);
ind1y = ind1(2,:);
ind1z = ind1(3,:);
ind2x = ind2(1,:);
ind2y = ind2(2,:);
ind2z = ind2(3,:);
lines = cell(length(ind),3);

for ii = 1:length(ind)
    line = false(truel,truel,truel);
    [r,c,h] = intline3(ind1x(ii),ind2x(ii),ind1y(ii),ind2y(ii),...
        ind1z(ii),ind2z(ii));
    rch = [r c h];
    rch = rch(sum(rch>0&rch<=truel,2)==3,:);
    [rchlength,~] = size(rch);
    for jj = 1:rchlength
        line(rch(jj,1),rch(jj,2),rch(jj,3)) = true;
    end
    templine = {line,ind(:,ii).',rchlength};
    lines(ii,:) = templine;
end
lines = lines(~cellfun('isempty',lines(:,1)),:);