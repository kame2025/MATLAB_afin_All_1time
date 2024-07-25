function ten_Multipul(mp2, imageFolder, IMG, tLenskosuu, yLenskosuu, magnification, pix, pix2, y_axis, x_axis)
    % mp2とfp2をワークスペースに出力
    assignin('base', 'mp2', mp2);

    Allhairetu = numel(mp2);
    INhairetu = Allhairetu / 2;
    Ptate = zeros(1,1000); %zeros(1,1000000)これは配列を1～1000000まで事前に作って，処理を高速化させている
    Pyoko = zeros(1,1000);
    Tateset = zeros(1,1000);
    saitei = 5; %mp2(5,1),mp2(5,1)から下のものを測定する
    Alllenstate = zeros(1,1000);
    lenstate = zeros(1,1000);
    lensyoko = zeros(1,1000);
    plot_statas = {};

    tate = mp2(3,2) - mp2(1,2); %縦の長さの中にa=333.91=7680
    yoko = mp2(2,1) - mp2(1,1); %横の長さ ""   b=c=187.83=4320

    for i = 1:INhairetu
        Ptate(i) = mp2(i,2) - mp2(1,2); %pointのy軸　"
        Pyoko(i) = mp2(i,1) - mp2(1,1); %pointのx軸を抽出
        saitei = saitei + 1;
    end
    
    assignin('base', 'INhairetu', INhairetu);
    ttLenskosuu = tLenskosuu * 2; %668  /23して*2したレンズの総数

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
    ee = 0;

    for i = 1:INhairetu
            a = 0;
            b = 0;
        if Tateset(i) == 0 % 偶数
            for x = pix2:pix:y_axis
                for y = pix2:pix:x_axis
                    if a == lenstate(i) && b == lensyoko(i)
                        IMG(x, y, 1) = 255; % (縦,横,1 or 2 or 3)
                        b = b + 1; 
                    end
                end
                a = a + 1;
            end

        else % 奇数  
            for x = pix:pix:y_axis
                for y = pix:pix:x_axis
                    if a == lenstate(i) && b == lensyoko(i)
                        IMG(x, y, 1) = 255; %(縦,横,1 or 2 or 3)
                        b = b + 1;    
                    end
                end
                a = a + 1;
            end
        end
        ee = ee + 1;
    end

    [subpixelRedCoordinates] = getSubpixelCoordinates(IMG);
    
    % 拡大後の座標を計算
    scaleFactor = magnification;
    newSubpixelRedCoordinates = subpixelRedCoordinates * scaleFactor;
    % 画像を保存
    L = imresize(IMG, magnification);   % 23の時333.91に対し、23.3626の時は328.73のため、23.3626似合わせようとすると、0.984倍する
    L1 = imcrop(L, [0 0 4320 7680]); % ↑1.007は縦がいい感じ(a=333c=187の時) 1.02
    imwrite(L1, fullfile(imageFolder, sprintf('second_afin_%d_%d_%.5f.png', tLenskosuu, yLenskosuu, magnification)));

    plot_statas{end+1} = newSubpixelRedCoordinates;
    disp('Red Subpixel Coordinates:');
    disp(newSubpixelRedCoordinates);

    % 座標を保存して次のスクリプトで使用
    save(fullfile(imageFolder, 'second_coordinates.mat'), 'plot_statas');
end
