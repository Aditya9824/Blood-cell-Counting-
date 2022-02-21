% Red Blood Cell Counting Using Watershed Algorithm (In-built Functions)
clc;clear all; close all;

%% Image Acquisition
I = imread('Dataset/input_4.jpg');
figure('NumberTitle', 'off', 'Name', 'Image Acquisition');
imshow(I)
title('Original Image');

%% Image Pre-processing
I=imresize(I, [182 277]);
Igray = rgb2gray(I);

Ithres = adapthisteq(Igray);

figure('NumberTitle', 'off', 'Name', 'Image Pre-processing');
subplot(1, 3, 1);
imshow(I)
title('Original Image');

subplot(1, 3, 2);
imshow(Igray)
title('Grayscale Image');

subplot(1, 3, 3);
imshow(Ithres)
title('Adaptive Histogram Equalized Image');

%% Image Enhancement
Ithres = adapthisteq(Igray);

bin = imbinarize(Ithres ,graythresh(Ithres));

BW1 = imopen(bin, 400);

BW2 = ~BW1;

filled = imfill(BW2,'holes');

se = getnhood(strel('disk', 3));
erodedI = erosion(filled,se);

figure('NumberTitle', 'off', 'Name', 'Image Enhancement');
subplot(2, 3, 1);
imshow(Ithres)
title('Adaptive Threshold Image');

subplot(2, 3, 2);
imshow(bin)
title('Binary Thresholded Image');

subplot(2, 3, 3);
imshow(BW1)
title('Image after Opening Morphological Operation');

subplot(2, 3, 4);
imshow(BW2)
title('Inversion of the previous Image for Processing');

subplot(2, 3, 5);
imshow(filled)
title('Holes Filled');

subplot(2, 3, 6);
imshow(erodedI);
title('Image after Erosion Morphological Operation');

%% Image Segmentation
% Watershed Algorithm
% Applying watershed to separate overlapped cells
D = bwdist(erodedI);
D = imgaussfilt(D, 0.1);

L = watershed(D, 26);

figure('NumberTitle', 'off', 'Name', 'Image Segemantation');
subplot(1, 2, 1);
imshow(L)
title('Watershed Segmentation');

L(erodedI) = 0;
BW3 = L == 0;

subplot(1, 2, 2);
imshow(BW3)
title('Segmentated Image');

%% Image Post-Processing and Counting
stats = regionprops('table',BW3,'Area');

wbc = bwareafilt(BW3,[295 50000]);

se = getnhood(strel('disk', 3));
wbc = erosion(wbc,se);

[centres1, radii1, metric1] = imfindcircles(wbc,[7,100]);

disp("WBC count-")
disp(size(centres1, 1))

rbc = bwareafilt(BW3, [1 294]);

[centres2, radii2, metric2] = imfindcircles(rbc, [1,255]);

disp("RBC count-")
disp(size(centres2, 1))

figure('NumberTitle', 'off', 'Name', 'Image Post-processing');
subplot(2, 2, 1);
imshow(wbc)
title('WBC Segmented Image');

subplot(2, 2, 2);
imshow(I)
viscircles(centres1, radii1,'LineStyle','--');
title(['WBC count is: ',num2str(size(centres1, 1))])

subplot(2, 2, 3);
imshow(rbc)
title('RBC Segmented Image');

subplot(2, 2, 4);
imshow(I)
viscircles(centres2, radii2,'LineStyle','--');
title(['RBC count is: ',num2str(size(centres2, 1))])