clc; close all; imtool close all; clear;

result_Dir = 'C:\Users\SISLa\MATLAB\Projects\afin_All_1time\出力結果\ten';

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
mp_length = length(mp);

% transformation_matrix関数を呼び出し
[registered] = transformation_matrix(result_Dir, J2, imds, plot_statas, mp, true, mp_length);
2
% [mp2, fp] = cpselect(registered, ten, 'Wait', true);
mp2 = [1069.75000000000	1330.25000000000
5469.75000000000	1332.75000000000
1070.25000000000	9005.25000000000
5470.25000000000	9006.25000000000
3047.00000000000	3734
3637	3579.00000000000
4058	3675.00000000000
4675	3663.00000000000
3371	4201
3710	4166
4166	4177
4585.50000000000	4176
2966.00000000000	4519.00000000000
3547	4589
4107	4586
4481	4586.00000000000
3033.00000000000	4988
3522	4939
3897	4963
4363	4985.00000000000
3254	5327.00000000000
3675	5300.00000000000
3954.00000000000	5253
4409	5241
3183.00000000000	5771
3628.00000000000	5769
4058.00000000000	5827
4457	5826
2918	6231
3440.00000000000	6236
4022	6236
4619	6222];

mp_length = length(mp2)

ten_Multipul(mp2, result_Dir,IMG ,xlens, ylens, magnification,pix, pix2, y_axis, x_axis) %任意のplotした点のten画像を作成
3
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~再度抽出，５点目以降を修正
% load_photo関数を呼び出し
[imds, ten, plot_statas] = load_photo(result_Dir, xlens, ylens, magnification, false); %任意のplotした点のten画像の読み込み
4
[registered] = transformation_matrix(result_Dir, registered, imds, plot_statas, mp2, false, mp_length); %任意のplotした点のten画像とregisterのafin変換を行う

imwrite(registered,"afin.png");

% [registered] = transformation_matrix(result_Dir, registered, imds, plot_statas, mp2); %任意のplotした点のten画像とregisterのafin変換を行う

