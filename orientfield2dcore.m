function [sumi,directi,maxi,sumr,maxr,directr] = orientfield2dcore(origimage,l1,lines,radius)
[r,c,h] = size(origimage);
image = primaryorientationfield(origimage,lines);
image = image.*l1;

ang = cell2mat(lines(:,2));

align = zeros(r,c,h,length(ang));
secweight = image;
sumr = normalise(sum(secweight,4));
maxr = normalise(max(secweight,[],4));
directr = normalise(std(secweight,1,4));
[image,indices] = max(image,[],4);
angimage = ang(indices);
disp(['Computing secondary orientation field: ' ...
    datestr(now,'HH:MM:SS.FFF')]);
for ii = 1:length(ang)
    disp([num2str(ii) ' of ' num2str(length(ang)) ' | ' ...
        datestr(now,'HH:MM:SS.FFF')]);
    line = lines{ii,1};
    [rind,cind] = find(line);
    wtemp = zeros(r+l1-1,c+l1-1,h,length(rind));
    angtemp = zeros(r+l1-1,c+l1-1,h,length(rind));
    for jj = 1:length(rind)
        wtemp(rind(jj):rind(jj)+r-1,cind(jj):cind(jj)+c-1,:,jj) = image;
        angtemp(rind(jj):rind(jj)+r-1,cind(jj):cind(jj)+c-1,:,jj) = ...
            angimage;
    end
    wtemp = wtemp(radius+1:end-radius,radius+1:end-radius,:,:);
    angtemp = angtemp(radius+1:end-radius,radius+1:end-radius,:,:);
    angtemp = cos(2.*(angtemp-ang(ii)));
    align(:,:,:,ii) = sum(wtemp.*angtemp,4);
end
image = align;
clear align;
sumi = sum(image,4);
directi = std(image,1,4);
maxi = max(image,[],4);
sumi = normalise(sumi);
directi = normalise(directi);
maxi = normalise(maxi);