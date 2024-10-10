clc; close all; imtool close all; clear;
I = imread('030A0229.JPG');
J = imrotate(I, 90);
A = imcrop(J, [500 100 4319 7680]); %img2

I2 = imread('030A0231.JPG');
J3 = imrotate(I2, 90);
B = imcrop(J3, [500 100 4319 7680]); %img2

C = imfuse(A,B,'blend','Scaling','joint');
imshow(C)
imwrite(C,'my_blend_overlay.png');