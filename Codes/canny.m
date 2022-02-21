clc;clear all;close all;
input = imread('input_canny.jpeg');
figure('NumberTitle', 'off', 'Name', 'RBC counting using Canny');
subplot(2,3,1);
imshow(input)
title('Orignal Image')
grayImage = rgb2gray(input);
subplot(2,3,2);imshow(grayImage)
title('Gray Scale Image')
[~, threshold] = edge(grayImage, 'canny');
fudgeFactor = 1.5;
cannyEdgeImage = edge(grayImage,'canny', threshold*fudgeFactor);
subplot(2,3,3);imshow(cannyEdgeImage)
title('Canny Edge Detected Image')
se90 = strel('line', 1, 90);
se0 = strel('line', 1, 0);
dilatedImage= imdilate(cannyEdgeImage, [se90 se0]);
subplot(2,3,4);imshow(dilatedImage)
title('Dilated Image')
borderClearedImage= imclearborder(cannyEdgeImage);
% Filling the holes of above processed image
imageWithFilledHoles = imfill(borderClearedImage,'holes');
% figure,imshow(imageWithFilledHoles)
% title('Image with Filled Holes')
% Extrating the circle on the basis of area of a cell
extractCircle = bwpropfilt(imageWithFilledHoles,'area',[100 750]);
connectedComponent = bwconncomp(extractCircle, 26);
circularCellCount = connectedComponent.NumObjects;
subplot(2,3,5);imshow(borderClearedImage)
title(['Total number of cells = ',num2str(circularCellCount)])
% Total number of circular cells
fprintf('%s %d\n','Total number of cells are ',circularCellCount);