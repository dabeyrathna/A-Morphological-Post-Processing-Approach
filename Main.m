%% INITIALIZATION
clc;
clear all;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[file1,path1] = uigetfile({'*.png';'*.jpg'},...
               'Select the segmentation mask','data/');

if isequal(file1,0)
   disp('User selected Cancel')
   return
end

[file2,path2] = uigetfile({'*.png';'*.jpg'},...
               'Select the original image','data/');

I = imread(fullfile(path1, file1));

flag = 0;
if isequal(file2,0)
   flag = 1;
else
    Im = imread(fullfile(path2, file2));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
figure, imshow(cell_area); 

if flag == 0
    output_Im = imfuse(Im,cell_area,'blend');
    figure,imshow(output_Im);
end
%%END

