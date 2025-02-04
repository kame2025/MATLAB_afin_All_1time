%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~４点抽出
clc; close all; imtool close all; clear;

I = imread('IMG_0001.JPG');
%I = imread('8J2.JPG');
J=imrotate(I,90);
J2=imcrop(J,[100 0 4319 7680]); % 4320 7680
imwrite(J2,"jiJ2en.jpg")
fname = char(datetime('now','TimeZone','local','Format','d-MM HH-mm-ss')); %日付

% 画像読み込み
img1 = imread("25-06 18-39-25.jpg"); %afinkai_29-06-2023 18-02-44_.jpg
img2 = J2;
img3 = img1;
img3(:,:,:) = 0; %色の指定

% コントロールポイントの設定
[mp,fp1] = cpselect(img2,img1,'Wait',true);
%変換行列の導出
% mp=[817.250000000000	1028.75000000000; 4239.25000000000	1033.25000000000; 829.250000000000	6987.75000000000; 4257.25000000000	6997.25000000000]; %IMG_0001
% fp1=[12.7500000000000	12.7499999999991; 4318.75000000000	12.7499999999991; 12.7500000000000	7664.25000000000; 4318.75000000000	7664.25000000000]; %IMG_0001

tform=fitgeotrans(mp,fp1,'projective');
% 
% % レジストレーション
registered=imwarp(img2,tform);
% 
% % 結果表示
% imshowpair(img1,registered,'diff');
aaa="1回目終了"
%imwrite(registered,"afin"+fname+"1.jpg");
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~再度抽出，５点目をとりたい
[mp2,fp2] = cpselect(registered,img1,'Wait',true);

%mp2=[1045	1330; 5345	1330; 1045	8989; 5344	8991; 3006	2946; 3468	2931; 3895	2944; 4215	2922; 3011	3298; 3517	3281; 3953	3307; 4388	3330; 3033.00000000000	3694; 3433	3705; 3849.00000000000	3714; 4558	3715.00000000000; 3077.00000000000	3974; 3371	3993; 3613	4006; 3955.00000000000	4004; 4229	3983; 3088	4196; 3292	4194; 3601.00000000000	4205; 4011.00000000000	4204; 3156	4405; 3555	4392; 3909	4382; 4307	4390; 3271	4710; 3614	4709; 3954.00000000000	4732; 4297	4730; 2973	5108; 3418	5163; 3772	5176.00000000000; 4103	5187; 4320	5174; 2996	5553; 3418	5562; 3851.00000000000	5537; 4365	5547; 4661	5545; 2984	5889; 3556.00000000000	5864; 4020.00000000000	5852; 4352	5863; 2858.00000000000	6154; 3360	6176; 4066	6060; 4410	6084; 3029	6400; 3589	6388.00000000000; 4329	6420];

Allhairetu = numel(mp2);
INhairetu = Allhairetu/2;
Ptate=[];
Pyoko=[];
h=1;
j=1;
Tateset=[];
saitei=5; %mp2(5,1),mp2(5,1)から下のものを測定する

tate=mp2(3,2)-mp2(1,2); %縦の長さの中にa=333.91=7680
yoko=mp2(2,1)-mp2(1,1); %横の長さ ""   b=c=187.83=4320

for i=1:1:INhairetu
    Ptate(i)=mp2(i,2)-mp2(1,2); %pointのy軸　"
    Pyoko(i)=mp2(i,1)-mp2(1,1); %pointのx軸を抽出
    saitei=saitei+1;
end

d=1.5*sqrt(2); %2.1213
pix=int32(((d/90.80)*1000)); %白線の線幅を画素数（整数,32 ビット符号付き整数）で表現(pix)
pix2=int32(((d/90.80)*1000)/2);
pix3=pix2*2;

tLenskosuu=328; %334-327
yLenskosuu=184; %188-184
ttLenskosuu=656; %668  /23して*2したレンズの総数

for i=1:1:INhairetu
    Alllenstate(i)=round((ttLenskosuu*Ptate(i))/tate); %img1の全体(668)のlensの位置を測定
    if Alllenstate(i)>=0
        Tateset(i) = rem(Alllenstate(i),2); %余りを判定して，奇数or偶数を判断
    else
        Tateset(i) = 1;
    end
end 
%~~ここまでは正しい
%プログラム自体はあってる．
%ここから変更するのはすべての中でどの位置にとどまっているかを確認する必要がある．



for i=1:1:INhairetu
    if Tateset(i) ~= 0
        if Ptate(i) >= 0
            if Tateset(i) ~= 0
                lenshitotu = tate/tLenskosuu;
                Ptate(i)=Ptate(i)+lenshitotu;
                lenstate(i)=round((tLenskosuu*Ptate(i))/tate); %img1(334)のlensの位置を測定
                lensyoko(i)=round((yLenskosuu*Pyoko(i))/yoko); %img1(188)のlensの位置を測定
            end
        else
            Tateset(i) = 1; %余りを判定して，奇数or偶数を判断
            lenstate(i) = 0;
            lensyoko(i)=round((yLenskosuu*Pyoko(i))/yoko); %img1(188)のlensの位置を測定
            bbb="通ったよ"
        end
        kkk="奇数判定したよ"
    else
        lenstate(i)=round((tLenskosuu*Ptate(i))/tate); %img1(334)のlensの位置を測定
        lensyoko(i)=round((yLenskosuu*Pyoko(i))/yoko); %img1(188)のlensの位置を測定
        kkk="偶数判定したよ"
    end
    
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~抽出した点にplot
yoko=4320; %moto= c=191or192, 4500 tate=7560 7530 4300,7530 23/4/24までyoko=4220,tate=7530　%a=333.91=7680 c=187.83=4320(一番きれいな数字)
tate=7680; 
ee=0;
for i=1:1:INhairetu
    if Tateset(i) == 0 %~=0は赤点で示した場所
        ccc="偶数"
        a=0;
        b=0;
        for x=pix2:pix:tate %赤点のほう
            if a ~= lenstate(i)
                for y=pix2:pix:yoko
                    img3(x,y,3)=255; %(縦,横,1 or 2 or 3)
                    img3(x+1,y,3)=255; %(縦,横,1 or 2 or 3)
                    img3(x,y+1,3)=255; %(縦,横,1 or 2 or 3)
                    img3(x+1,y+1,3)=255; %(縦,横,1 or 2 or 3)
                end
            else
                for y=pix2:pix:yoko
                    if b ~= lensyoko(i)
                        img3(x,y,3)=255; %(縦,横,1 or 2 or 3)
                        img3(x+1,y,3)=255; %(縦,横,1 or 2 or 3)
                        img3(x,y+1,3)=255; %(縦,横,1 or 2 or 3)
                        img3(x+1,y+1,3)=255; %(縦,横,1 or 2 or 3)
                    else
                        for j=1:1:20
                            img3(x,y,1)=255; %(縦,横,1 or 2 or 3)
                            img3(x+j,y,1)=255; %(縦,横,1 or 2 or 3)
                            img3(x,y+j,1)=255; %(縦,横,1 or 2 or 3)
                            img3(x+j,y+j,1)=255; %(縦,横,1 or 2 or 3)
                        end
                        a
                        b
                    end  
                    b=b+1;
                end
            end
            a=a+1;
        end
        for x=pix:pix:tate
            for y=pix:pix:yoko
                img3(x,y,3)=255; %(縦,横,1 or 2 or 3)
                img3(x+1,y,3)=255; %(縦,横,1 or 2 or 3)
                img3(x,y+1,3)=255; %(縦,横,1 or 2 or 3)
                img3(x+1,y+1,3)=255; %(縦,横,1 or 2 or 3)  
            end
        end
    else
        ccc="奇数"
        a=0;
        b=1;
        for x=pix2:pix:tate
            for y=pix2:pix:yoko
                img3(x,y,3)=255; %(縦,横,1 or 2 or 3)
                img3(x+1,y,3)=255; %(縦,横,1 or 2 or 3)
                img3(x,y+1,3)=255; %(縦,横,1 or 2 or 3)
                img3(x+1,y+1,3)=255; %(縦,横,1 or 2 or 3)  
            end
        end    
        for x=pix:pix:tate
            if a ~= lenstate(i)
                for y=pix:pix:yoko
                    img3(x,y,3)=255; %(縦,横,1 or 2 or 3)
                    img3(x+1,y,3)=255; %(縦,横,1 or 2 or 3)
                    img3(x,y+1,3)=255; %(縦,横,1 or 2 or 3)
                    img3(x+1,y+1,3)=255; %(縦,横,1 or 2 or 3)
                end
            else
                for y=pix:pix:yoko
                    if b ~= lensyoko(i)
                        img3(x,y,3)=255; %(縦,横,1 or 2 or 3)
                        img3(x+1,y,3)=255; %(縦,横,1 or 2 or 3)
                        img3(x,y+1,3)=255; %(縦,横,1 or 2 or 3)
                        img3(x+1,y+1,3)=255; %(縦,横,1 or 2 or 3)
                    else
                        for j=1:1:20
                            img3(x,y,1)=255; %(縦,横,1 or 2 or 3)
                            img3(x+j,y,1)=255; %(縦,横,1 or 2 or 3)
                            img3(x,y+j,1)=255; %(縦,横,1 or 2 or 3)
                            img3(x+j,y+j,1)=255; %(縦,横,1 or 2 or 3)
                        end
                        a
                        b
                    end  
                    b=b+1;
                end
            end
            a=a+1;
        end
    end
    ee=ee+1;
end
% vertical = ((d / 90.80) * 1000) / pix;
% L = imresize(img3, vertical);
% % 必要に応じてクロップして7680x4320ピクセルに調整
% L1 = imcrop(L, [0 0 4320 7680]); 
% p=((d/90.80)*1000)/23; %23.0158を23にしているため，%1.0158倍している 1.530=(tate-yoko)/328.9
L = imresize(img3, 1.01739);   % 1.017 23の時333.91に対し，23.3626の時は328.73のため，23.3626似合わせようとすると，0.984倍する
L1=imcrop(L,[0 0 4320 7680]); %↑1.007は縦がいい感じ(a=333c=187の時) 1.02

imwrite(img3,"tenten"+fname+".jpg");
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~再度抽出，５点目以降を修正
[mp3,fp3] = cpselect(registered,L1,'Wait',true);
% fp3(1,:)=fp1(1,:);
% fp3(2,:)=fp1(2,:);
% fp3(3,:)=fp1(3,:);
% fp3(4,:)=fp1(4,:);
% %fp3=[12.375 12.375; 4311.4375 12.3125; 12.3125 7675.4375; 4311.4375 7675.5625; 433.125 129.625; 1777.875 445.625; 2853.875 819.875; 3848.375 550.625; 1088.375 1532.875; 2105.375 1545.375; 3181.375 1545.625; 3929.875 1662.125; 877.875  2796.125; 2246.125 2855.375; 2947.625  2667.875; 3953.375 2738.125; 1146.125 3767.375; 2234.375 3731.875; 3157.875 3650.375; 4023.375 3884.375; 222.875 4784.125; 2128.875 4679.125; 3217.1250 4410.125; 4199.125 4643.625; 935.375 5638.375; 2199.125 5544.875; 3567.375 5626.125; 4187.125 5802.125; 1205.375 6608.625; 3017.625 6667.875; 3848.375 7076.625;];
% %|->31個
tform2=fitgeotrans(mp2,fp3,'projective'); %polynomial
% 
% % レジストレーション
registered2=imwarp(registered,tform2);
% imshowpair(L1,registered2,'diff');

imwrite(registered2,"afin"+fname+".jpg");

