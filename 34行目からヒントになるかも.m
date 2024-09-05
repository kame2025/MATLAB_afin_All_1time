clc; close all; imtool close all; clear;

img = imread('result.png');
imshow(img);
axis tight;
[height, width, ~] = size(img);

% スケーリングされた範囲を計算
xRange = [0 width];
yRange = [0 height];
xlim(xRange);
ylim(yRange);

% X軸の目盛りとラベルの設定
xTicks = 0:21:width; % X軸の目盛り間隔を21ピクセルごとに設定
xLabels = arrayfun(@(x) num2str(x/21), xTicks, 'UniformOutput', false); % ラベルを1, 2, 3, ...に設定

% X軸の表示ラベルを50の倍数だけに絞る
showLabels = mod(cellfun(@str2double, xLabels), 10) == 0; % 50の倍数だけを表示
set(gca, 'XTick', xTicks(showLabels));
set(gca, 'XTickLabel', xLabels(showLabels));

% Y軸の目盛りとラベルの設定
yTicks = 0:21:height; % Y軸の目盛り間隔を21ピクセルごとに設定
yLabels = arrayfun(@(y) num2str(y/21), yTicks, 'UniformOutput', false); % ラベルを1, 2, 3, ...に設定

% Y軸の表示ラベルを50の倍数だけに絞る
showLabels = mod(cellfun(@str2double, yLabels), 10) == 0; % 50の倍数だけを表示
set(gca, 'YTick', yTicks(showLabels));
set(gca, 'YTickLabel', yLabels(showLabels));

axis on;

continueRun = true; % ループを続けるフラグ
while continueRun
    [x, y] = ginput(1); % 1回クリックで座標を取得
    disp(['Clicked at X: ', num2str(x), ', Y: ', num2str(y)]);
end
