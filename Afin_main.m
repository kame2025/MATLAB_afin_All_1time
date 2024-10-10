clc; close all; imtool close all; clear;

result_Dir = 'C:\Users\SISLa\MATLAB\Projects\afin_All_1time\出力結果\ten';

% 初期設定
xlens = 329;
ylens = 188;
% magnification = 1.01739;

% 画像の読み込みと前処理
I = imread('030A0229.JPG');
J = imrotate(I, 90);

J2 = imcrop(J, [500 100 4319 7680]); %img2
IMG = J2;
IMG(:,:,:) = 0; %色の指定 今だけ入れてる→あとから消すように変更する

% 初期値設定
d = 1.5 * sqrt(2); % 12 * 0.0908  
pix = round((d / 90.80) * 1000); % 白線の線幅を画素数で表現(pix)
pix2 = round(pix / 2);
pix3 = (d / 90.80) * 1000; % 白線の線幅を画素数で表現(pix)
magnification = pix3/pix;

x_axis = 5000; % 横のサイズ184.915675
y_axis = 8000; % 縦のサイズ328.7389

% ten_main関数を呼び出し
ten_main(result_Dir, xlens, ylens, magnification, IMG, pix, pix2, y_axis, x_axis);

% load_photo関数を呼び出し
[imds, ten, plot_statas] = load_photo(result_Dir, xlens, ylens, magnification, true); %ten = img1

mp = [686.750000000000	733.250000000000
4287.75000000000	699.750000000000
690.750000000000	6875.75000000000
4224.75000000000	6985.25000000000];

mp_length = length(mp);

% transformation_matrix関数を呼び出し
[registered] = transformation_matrix(result_Dir, J2, imds, plot_statas, mp, true, mp_length);

mp2 = [883.750000000000	912.249999999998
5277.25000000000	910.749999999998
883.750000000000	8594.25000000000
5275.25000000000	8595.25000000000
2586.00000000000	5480
3109	5472
3568.00000000000	5436
2550	5872
3169.00000000000	5887
3660.00000000000	5869
2574	6228
3164.00000000000	6227
3745.00000000000	6205];

mp_length = length(mp2);

ten_Multipul(mp2, result_Dir,IMG ,xlens, ylens, magnification,pix, pix2, y_axis, x_axis) %任意のplotした点のten画像を作成

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~再度抽出，５点目以降を修正
% load_photo関数を呼び出し
[imds, ten, plot_statas] = load_photo(result_Dir, xlens, ylens, magnification, false); %任意のplotした点のten画像の読み込み

[registered] = transformation_matrix(result_Dir, registered, imds, plot_statas, mp2, false, mp_length); %任意のplotした点のten画像とregisterのafin変換を行う
