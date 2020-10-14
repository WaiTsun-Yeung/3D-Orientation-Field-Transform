function data = normalise(data)
%Linearly change most of the range of DATA to between 0 and 1.
data = im2double(data);
data = data./median(median(median(data,1),2),3).*0.1;