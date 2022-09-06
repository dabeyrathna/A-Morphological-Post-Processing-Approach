%% INITIALIZATION
clc;
clear all;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I = imread('data/y1.png');
Im = imread('data/yo.png');

[rows, columns, numberOfColorChannels] = size(I);
if numberOfColorChannels > 1
	I = rgb2gray(I);
end
BW = double(I);
w = imbinarize(BW);
e = edge(w);

cc = bwconncomp(BW);
L1 = labelmatrix(cc);
temp_BW = BW;
final_BW = cat(3,BW,BW,BW);
component_images = {};

for o1 = 1:cc.NumObjects
    msk1 = temp_BW .* (L1 == o1);   
    [new_connObj, branchObj, sarr, fskel] = morpho(msk1);
    component_images(o1).image = new_connObj;
    component_images(o1).branchObj = branchObj;
    component_images(o1).sarr = sarr;
end

[final_BW, cell_area, c1] = Instance_segments(component_images,I, final_BW,cc,e);
figure(1), imshow(cell_area); 
% output_Im = imfuse(Im,cell_area,'blend');
% figure(2),imshow(output_Im);

%%END

