function [subpixelRedCoordinates] = getSubpixelCoordinates(K, flag, kaisuu)
    % 赤色のピクセル座標を取得
    [redRows, redCols] = find(K(:,:,1) == 255 & K(:,:,2) == 0 & K(:,:,3) == 0);
    redCoordinates = [redRows, redCols];
    assignin('base', 'redCoordinates', redCoordinates);

    % サブピクセル精度の座標を取得
    subpixelRedCoordinates = [];
    
    for i = 1:length(redRows)
        % ピクセル近傍のサブピクセル精度の値を補間
        row = redRows(i);
        col = redCols(i);
        
        % 境界チェックを追加
        if row < size(K, 1) && col < size(K, 2)
            % バイリニア補間を使用してサブピクセル位置を求める
            [xSubpixel, ySubpixel] = subpixelPosition(K(:,:,1), row, col);
            newCoordinate = [xSubpixel, ySubpixel];
        else
            % 境界外の場合はそのままの座標を使用
            newCoordinate = [row, col];
        end

        % 新しい座標を追加  どうにかしよ
        subpixelRedCoordinates = [subpixelRedCoordinates; newCoordinate];

        % 新しい座標を表示
        fprintf('Subpixel Red Coordinate %d: (%.2f, %.2f)\n', i, newCoordinate(1), newCoordinate(2));
    end

    % 入れ替え処理を行う場合
    if flag
        subpixelRedCoordinates = replacement(subpixelRedCoordinates, flag, kaisuu);
    end
end

function [xSubpixel, ySubpixel] = subpixelPosition(channel, row, col)
    % バイリニア補間
    % 境界チェック
    if row < size(channel, 1) && col < size(channel, 2)
        % 4つの隣接するピクセルの値
        f00 = double(channel(row, col));
        f01 = double(channel(row, col+1));
        f10 = double(channel(row+1, col));
        f11 = double(channel(row+1, col+1));

        % xとyのサブピクセル位置を決定
        xSubpixel = row + (f10 - f00) / (f10 + f00 + f11 + f01);
        ySubpixel = col + (f01 - f00) / (f01 + f00 + f11 + f10);
    else
        xSubpixel = row;
        ySubpixel = col;
    end
end

function subpixelRedCoordinates = replacement(subpixelRedCoordinates, flag, kaisuu)
    % 全ての座標の1列目と2列目を入れ替える
    subpixelRedCoordinates = subpixelRedCoordinates(:, [2, 1]);

    % 行の入れ替え
    if flag
        if size(subpixelRedCoordinates, 1) >= 3
            sub = subpixelRedCoordinates(3,:);
            subpixelRedCoordinates(3,:) = subpixelRedCoordinates(2,:);
            subpixelRedCoordinates(2,:) = sub;
        end
    else
        numPoints = size(subpixelRedCoordinates, 1);
        
        % 最後の2つの赤点を3番目と4番目に移動
%         if numPoints > 4
%             % 最後の2つの点を取得
%             lastPoint1 = subpixelRedCoordinates(end, :);
%             lastPoint2 = subpixelRedCoordinates(end-1, :);
% 
%             % 3番目と4番目に移動
%             subpixelRedCoordinates(3, :) = lastPoint2;
%             subpixelRedCoordinates(4, :) = lastPoint1;
%         end
        if size(subpixelRedCoordinates, 1) == kaisuu
            sub = subpixelRedCoordinates(3,:);
            subpixelRedCoordinates(3,:) = subpixelRedCoordinates(2,:);
            subpixelRedCoordinates(2,:) = sub;
        end
    end
end
