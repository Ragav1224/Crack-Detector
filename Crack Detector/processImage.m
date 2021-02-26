function y = processImage(j)
BW2 = imfill(j,'holes');

res = BW2-j;

noisRem = medfilt2(res);

se = strel("line", 5, 5); 
dilate = imdilate(noisRem, se); 

se = strel("line", 5, 5); 
er = imerode(dilate, se); 

y = er;