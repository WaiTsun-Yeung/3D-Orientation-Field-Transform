function output = biglocalsad(lsad,l,threshold)
if nargin<3
    threshold = 0.375;
end
radius = floor(l/2);
lsad = normalise(lsad);
try
    se = strel('sphere',round(radius*2));
catch
    se = strel('ball',round(radius*2),round(radius*2));
end
tlsad = lsad>=threshold;
dtlsad = imdilate(tlsad.*lsad,se);
output = dtlsad+(dtlsad==0).*lsad;