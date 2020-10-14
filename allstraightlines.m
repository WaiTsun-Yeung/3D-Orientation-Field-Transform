function lines = allstraightlines(l)
%ALLSTRAIGHTLINES Compute line structural elements of all angles with the 
%given length l.
%The value l will be rounded to the nearest odd number for simplicity.
trueradius = floor(l/2);
l = trueradius*2+1;

%Bresenham mid point circle algorithm.
xx = (0:midpoint(trueradius)).';
yy = round(sqrt(trueradius^2-xx.^2));
if xx(end)~=yy(end)
    x = [xx;yy(end:-1:1)];
    y = [yy;xx(end:-1:1)];
else
    x = [xx;yy(end-1:-1:1)];
    y = [yy;xx(end-1:-1:1)];
end
x = [x;x(end-1:-1:2)];
y = [y;-y(end-1:-1:2)];


x2 = x + trueradius+1;
y2 = y + trueradius+1;
x1 = -x + trueradius+1;
y1 = -y + trueradius+1;
lines = cell(length(x),3);
for ii = 1:length(x)
    line = false(l);
    [r,c] = iptui.intline(x1(ii),x2(ii),y1(ii),y2(ii));
    rc = [c r];
    rc = rc(sum(rc>0&rc<=l,2)==2,:);
    for jj = 1:length(rc)
        line(rc(jj,1),rc(jj,2)) = true;
    end
    angle = -slope2angle(y(ii),x(ii),@atan);
    templine = {line,angle,sum(sum(line))};
    lines(ii,:) = templine;
end