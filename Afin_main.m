clc; close all; imtool close all; clear;

result_Dir = 'C:\Users\SISLa\MATLAB\Projects\afin_All\出力結果\ten';

% 初期設定
xlens = 328;
ylens = 188;
magnification = 1.01739;

% 画像の読み込みと前処理
I = imread('IMG_0001.JPG');
J = imrotate(I, 90);
J2 = imcrop(J, [100 0 4319 7680]); %img2
IMG = J2;
IMG(:,:,:) = 0; %色の指定 今だけ入れてる→あとから消すように変更する

% 初期値設定
d = 1.5 * sqrt(2); % 12 * 0.0908  
pix = round((d / 90.80) * 1000); % 白線の線幅を画素数で表現(pix)
pix2 = round(pix / 2);
pix3=pix2*2;

x_axis = 5000; % 横のサイズ184.915675
y_axis = 8000; % 縦のサイズ328.7389

% ten_main関数を呼び出し
ten_main(result_Dir, xlens, ylens, magnification, IMG, pix, pix2, y_axis, x_axis);

% load_photo関数を呼び出し
[imds, ten, plot_statas] = load_photo(result_Dir, xlens, ylens, magnification, true); %ten = img1

% 変換行列の導出
% [mp, fp] = cpselect(J2, ten, 'Wait', true);
mp = [818.000000000000	1029
4240	1034
832.000000000000	6987
4258	6995];
1
% transformation_matrix関数を呼び出し
[registered] = transformation_matrix(result_Dir, J2, imds, plot_statas, mp);
2
% [mp, fp] = cpselect(registered, ten, 'Wait', true);
mp2 = [1065	1338
5466	1335
1069	9009
5465	9010
3366	4207
4150	4194
3134	4816
4172	4779
3260	5322
4406	5200
3260	5950
4416	5890.00000000000];
ten_Multipul(mp2, result_Dir,IMG ,xlens, ylens, magnification,pix, pix2, y_axis, x_axis) %任意のplotした点のten画像を作成
3
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~再度抽出，５点目以降を修正
% load_photo関数を呼び出し
[imds, ten, plot_statas] = load_photo(result_Dir, xlens, ylens, magnification, false); %任意のplotした点のten画像の読み込み

[registered] = transformation_matrix(result_Dir, registered, imds, plot_statas, mp2); %任意のplotした点のten画像とregisterのafin変換を行う

