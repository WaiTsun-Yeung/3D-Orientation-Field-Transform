function combinedarray = combinetome(leftarray,rightarray)
if size(leftarray)~=size(rightarray)
    error('Input array dimensions don''t match.');
end
leftarray=im2uint8(leftarray);
rightarray=im2uint8(rightarray);
dim=size(leftarray);
c=dim(2);
dim(2)=c*2;
combinedarray=zeros(dim,'uint8');
combinedarray(:,1:c,:)=leftarray;
combinedarray(:,c+1:end,:)=rightarray;
implay(combinedarray);