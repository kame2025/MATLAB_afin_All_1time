clc; close all; clear;

% 動画の読み込み
videoFile = 'input_video.mp4';  % 入力動画ファイル名
vidObj = VideoReader(videoFile);

% 出力動画ファイルの設定
outputVideo = VideoWriter('output_video.avi');  % 出力する動画ファイル名
open(outputVideo);  % 動画ファイルの書き込みを開始

% 初期設定（元のスクリプトから引き継ぎ）
result_Dir = 'C:\Users\SISLa\MATLAB\Projects\afin_All_1time\出力結果\ten';
xlens = 329;
ylens = 188;
magnification = 1.01739;

% 各フレームに対する処理
while hasFrame(vidObj)
    frame = readFrame(vidObj);  % 動画のフレームを読み込む

    % フレームの回転、クロップ
    J = imrotate(frame, 90);
    J2 = imcrop(J, [500 100 4319 7680]);
    IMG = J2;
    IMG(:,:,:) = 0;  % 必要に応じて色の指定

    % ten_main関数の呼び出し
    ten_main(result_Dir, xlens, ylens, magnification, IMG, pix, pix2, y_axis, x_axis);

    % load_photo関数の呼び出し
    [imds, ten, plot_statas] = load_photo(result_Dir, xlens, ylens, magnification, true);

    % 変換行列の適用
    [mp, fp] = cpselect(J2, ten, 'Wait', true);
%     mp = [298.25, 606.25; 4125.75, 594.75; 322.25, 7208.75; 4114.75, 7257.75];  % 座標例
    mp_length = length(mp);

    [registered] = transformation_matrix(result_Dir, J2, imds, plot_statas, mp, true, mp_length);
    
    [mp2, fp] = cpselect(registered, ten, 'Wait', true);
%     mp2 = [380	701
%     4771	700
%     380	8386
%     4771	8388
%     1550.00000000000	3535.00000000000
%     2060	3539.00000000000
%     2645.00000000000	3587.00000000000
%     3157.00000000000	3586.00000000000
%     1479	4174.00000000000
%     2166	4163
%     2538	4162
%     2923.00000000000	4172
%     1488.00000000000	4706
%     2084	4692
%     2505	4619
%     3004	4607
%     1493	5217
%     2059	5188
%     2431	5182
%     2747.00000000000	5193
%     3074	5216
%     1537	5547
%     2161	5597
%     2631	5570
%     2957.00000000000	5594
%     3262	5593];
    
    mp_length = length(mp2);
    
    ten_Multipul(mp2, result_Dir,IMG ,xlens, ylens, magnification,pix, pix2, y_axis, x_axis) %任意のplotした点のten画像を作成

    [imds, ten, plot_statas] = load_photo(result_Dir, xlens, ylens, magnification, false); %任意のplotした点のten画像の読み込み

    [registered] = transformation_matrix(result_Dir, registered, imds, plot_statas, mp2, false, mp_length); %任意のplotした点のten画像とregisterのafin変換を行う

    % 処理結果を動画に保存
    writeVideo(outputVideo, registered);  % 処理されたフレームを書き込み
end

% 動画ファイルの書き込みを終了
close(outputVideo);
