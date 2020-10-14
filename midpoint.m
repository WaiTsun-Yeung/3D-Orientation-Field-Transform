function pt = midpoint(r)
if r < 2
    pt = 0;
    return
end
pts = (floor(r/sqrt(2)):ceil(r/sqrt(2))).';
flag = (abs((round(sqrt(r^2-(pts-1).^2))-round(sqrt(r^2-pts.^2)))-0.5)...
    <=0.5)&((round(sqrt(r^2-pts.^2))-pts)<=1);
truepts = pts(flag);
pt = truepts(1);