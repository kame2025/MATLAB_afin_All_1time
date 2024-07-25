clc; close all; imtool close all; clear;

result_Dir = 'C:\Users\SISLa\MATLAB\Projects\afin_All\出力結果\ten';

% 初期設定
xlens = 328;
ylens = 188;
magnification = 1.01739;

% 画像の読み込みと前処理
I = imread('IMG_0001.JPG');
J = imrotate(I, 90);
J2 = imcrop(J, [100 0 4319 7680]);

% 初期値設定
d = 1.5 * sqrt(2); % 12 * 0.0908  
pix = round((d / 90.80) * 1000); % 白線の線幅を画素数で表現(pix)
pix2 = round(pix / 2);

x_axis = 5000; % 横のサイズ184.915675
y_axis = 8000; % 縦のサイズ328.7389

% ten_main関数を呼び出し
generated_image_filename = ten_main(result_Dir, xlens, ylens, magnification, J2, pix, pix2, y_axis, x_axis);

% 画像処理後のファイルを読み込む
imageFolder = result_Dir;
filePattern = fullfile(imageFolder, '*.png');
imageFiles = dir(filePattern);

% ファイル名を取得し、数字の小さい順に並べ替える
fileNames = {imageFiles.name}';
[~, sortIdx] = sort(str2double(regexp(fileNames, '\d+', 'match', 'once')));
sortedFileNames = fileNames(sortIdx);

% 完全なファイルパスを作成
fullFilePaths = fullfile(imageFolder, sortedFileNames);

% 並べ替えたファイルパスでImageDatastoreを作成
imds = imageDatastore(fullFilePaths);

% 生成された画像ファイル名を指定
ten = imread(fullfile(result_Dir, generated_image_filename));

% 座標を読み込む
coordinatesFile = fullfile(imageFolder, 'coordinates.mat');
load(coordinatesFile, 'plot_statas');

% Control Point Selection Toolを使用して対応点を選択
[mp, fp1] = cpselect(J2, ten, 'Wait', true);

while hasdata(imds)
    [img, info] = read(imds);
    % 座標を代入
    fp1 = plot_statas{1};  % インデックス調整
    % 変換行列の導出
    tform = fitgeotrans(mp, fp1, 'projective');
    registered = imwarp(J2, tform);

    % ファイル名に注意して保存
    [~, name, ext] = fileparts(info.Filename);
    outputFile = fullfile(imageFolder, sprintf('afin_%s%s', name, ext));
    imwrite(registered, outputFile);
end

% 続けて2回目の処理
ten_Multipul(registered, ten, imageFolder, xlens, ylens, magnification,pix, pix2, y_axis, x_axis)

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~以下tenについて
function ten_Multipul(registered, img1, imageFolder)
    [mp2, fp2] = cpselect(registered, img1, 'Wait', true);

    Allhairetu = numel(mp2);
    INhairetu = Allhairetu / 2;
    Ptate = [];
    Pyoko = [];
    Tateset = [];
    saitei = 5; %mp2(5,1),mp2(5,1)から下のものを測定する

    tate = mp2(3,2) - mp2(1,2); %縦の長さの中にa=333.91=7680
    yoko = mp2(2,1) - mp2(1,1); %横の長さ ""   b=c=187.83=4320

    for i = 1:INhairetu
        Ptate(i) = mp2(i,2) - mp2(1,2); %pointのy軸　"
        Pyoko(i) = mp2(i,1) - mp2(1,1); %pointのx軸を抽出
        saitei = saitei + 1;
    end

    d = 1.5 * sqrt(2); %2.1213
    pix = int32((d / 90.80) * 1000); %白線の線幅を画素数（整数,32 ビット符号付き整数）で表現(pix)
    pix2 = int32((d / 90.80) * 1000 / 2);
    pix3 = pix2 * 2;

    tLenskosuu = 328; %334-327
    yLenskosuu = 184; %188-184
    ttLenskosuu = 656; %668  /23して*2したレンズの総数

    for i = 1:INhairetu
        Alllenstate(i) = round((ttLenskosuu * Ptate(i)) / tate); %img1の全体(668)のlensの位置を測定
        if Alllenstate(i) >= 0
            Tateset(i) = rem(Alllenstate(i), 2); %余りを判定して，奇数or偶数を判断
        else
            Tateset(i) = 1;
        end
    end 

    for i = 1:INhairetu
        if Tateset(i) ~= 0
            if Ptate(i) >= 0
                lenshitotu = tate / tLenskosuu;
                Ptate(i) = Ptate(i) + lenshitotu;
                lenstate(i) = round((tLenskosuu * Ptate(i)) / tate); %img1(334)のlensの位置を測定
                lensyoko(i) = round((yLenskosuu * Pyoko(i)) / yoko); %img1(188)のlensの位置を測定
            else
                Tateset(i) = 1; %余りを判定して，奇数or偶数を判断
                lenstate(i) = 0;
                lensyoko(i) = round((yLenskosuu * Pyoko(i)) / yoko); %img1(188)のlensの位置を測定
            end
        else
            lenstate(i) = round((tLenskosuu * Ptate(i)) / tate); %img1(334)のlensの位置を測定
            lensyoko(i) = round((yLenskosuu * Pyoko(i)) / yoko); %img1(188)のlensの位置を測定
        end
    end

    %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~抽出した点にplot
    yoko = 4320; % 横のサイズ
    tate = 7680; % 縦のサイズ
    img3 = zeros(tate, yoko, 3, 'uint8'); % 初期化
    ee = 0;

    for i = 1:INhairetu
        if Tateset(i) == 0 % 偶数
            a = 0;
            b = 0;
            for x = pix2:pix:tate
                if a ~= lenstate(i)
                    for y = pix2:pix:yoko
                        img3(x, y, 3) = 255; %(縦,横,1 or 2 or 3)
                        img3(x + 1, y, 3) = 255; %(縦,横,1 or 2 or 3)
                        img3(x, y + 1, 3) = 255; %(縦,横,1 or 2 or 3)
                        img3(x + 1, y + 1, 3) = 255; %(縦,横,1 or 2 or 3)
                    end
                else
                    for y = pix2:pix:yoko
                        if b ~= lensyoko(i)
                            img3(x, y, 3) = 255; %(縦,横,1 or 2 or 3)
                            img3(x + 1, y, 3) = 255; %(縦,横,1 or 2 or 3)
                            img3(x, y + 1, 3) = 255; %(縦,横,1 or 2 or 3)
                            img3(x + 1, y + 1, 3) = 255; %(縦,横,1 or 2 or 3)
                        else
                            for j = 1:20
                                img3(x, y, 1) = 255; %(縦,横,1 or 2 or 3)
                                img3(x + j, y, 1) = 255; %(縦,横,1 or 2 or 3)
                                img3(x, y + j, 1) = 255; %(縦,横,1 or 2 or 3)
                                img3(x + j, y + j, 1) = 255; %(縦,横,1 or 2 or 3)
                            end
                        end  
                        b = b + 1;
                    end
                end
                a = a + 1;
            end
            for x = pix:pix:tate
                for y = pix:pix:yoko
                    img3(x, y, 3) = 255; %(縦,横,1 or 2 or 3)
                    img3(x + 1, y, 3) = 255; %(縦,横,1 or 2 or 3)
                    img3(x, y + 1, 3) = 255; %(縦,横,1 or 2 or 3)
                    img3(x + 1, y + 1, 3) = 255; %(縦,横,1 or 2 or 3)  
                end
            end
        else % 奇数
            a = 0;
            b = 1;
            for x = pix2:pix:tate
                for y = pix2:pix:yoko
                    img3(x, y, 3) = 255; %(縦,横,1 or 2 or 3)
                    img3(x + 1, y, 3) = 255; %(縦,横,1 or 2 or 3)
                    img3(x, y + 1, 3) = 255; %(縦,横,1 or 2 or 3)
                    img3(x + 1, y + 1, 3) = 255; %(縦,横,1 or 2 or 3)  
                end
            end    
            for x = pix:pix:tate
                if a ~= lenstate(i)
                    for y = pix:pix:yoko
                        img3(x, y, 3) = 255; %(縦,横,1 or 2 or 3)
                        img3(x + 1, y, 3) = 255; %(縦,横,1 or 2 or 3)
                        img3(x, y + 1, 3) = 255; %(縦,横,1 or 2 or 3)
                        img3(x + 1, y + 1, 3) = 255; %(縦,横,1 or 2 or 3)
                    end
                else
                    for y = pix:pix:yoko
                        if b ~= lensyoko(i)
                            img3(x, y, 3) = 255; %(縦,横,1 or 2 or 3)
                            img3(x + 1, y, 3) = 255; %(縦,横,1 or 2 or 3)
                            img3(x, y + 1, 3) = 255; %(縦,横,1 or 2 or 3)
                            img3(x + 1, y + 1, 3) = 255; %(縦,横,1 or 2 or 3)
                        else
                            for j = 1:20
                                img3(x, y, 1) = 255; %(縦,横,1 or 2 or 3)
                                img3(x + j, y, 1) = 255; %(縦,横,1 or 2 or 3)
                                img3(x, y + j, 1) = 255; %(縦,横,1 or 2 or 3)
                                img3(x + j, y + j, 1) = 255; %(縦,横,1 or 2 or 3)
                            end
                        end  
                        b = b + 1;
                    end
                end
                a = a + 1;
            end
        end
        ee = ee + 1;
    end

    % 画像のリサイズと保存
    L = imresize(img3, 1.01739); 
    L1 = imcrop(L, [0 0 4320 7680]); 
    fname = 'output'; % 適切なファイル名に変更してください
    imwrite(L1, fullfile(imageFolder, sprintf('tenten%s.jpg', fname)));

    % 再度抽出
    [mp3, fp3] = cpselect(registered, L1, 'Wait', true);
    tform2 = fitgeotrans(mp2, fp3, 'projective'); 
    registered2 = imwarp(registered, tform2);
    imwrite(registered2, fullfile(imageFolder, sprintf('afin%s.jpg', fname)));
end

