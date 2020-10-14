function output = localsad(data,l,RAM)
radius = floor(l/2);
l = radius*2+1;
[r,c,h] = size(data);
output = zeros(r,c,h);
div = ceil(sqrt(r*c*h*l^3*8*7/RAM));
rd = ceil(r/div);
cd = ceil(c/div);
for mm=0:div-1
    for nn=0:div-1
        datatemp = data(max(1,mm*rd-radius+1):min(end,(mm+1)*rd+radius),...
            max(1,nn*cd-radius+1):min(end,(nn+1)*cd+radius),:);
        [rs,cs,~] = size(datatemp);
        temp = zeros(rs+l-1,cs+l-1,h+l-1,l^3);
        ll = 1;
        for ii = 1:l
            for jj = 1:l
                for kk = 1:l
                    temp(ii:ii+rs-1,jj:jj+cs-1,kk:kk+h-1,ll) = datatemp;
                    ll = ll+1;
                end
            end
        end
        outputtemp = std(temp,1,4);
        output(mm*rd+1:min(end,(mm+1)*rd),...
            nn*cd+1:min(end,(nn+1)*cd),:) = ...
            outputtemp(radius*(1+(mm~=0))+1:...
            end-radius*(1+(mm~=(div-1))),...
            radius*(1+(nn~=0))+1:end-radius*(1+(nn~=(div-1))),...
            radius+1:end-radius);
    end
end
output = normalise(1./(output+0.001));