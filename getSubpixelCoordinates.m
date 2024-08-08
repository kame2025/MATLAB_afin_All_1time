function [subpixelRedCoordinates] = getSubpixelCoordinates(K, flag, kaisuu)
    % 赤色のピクセル座標を取得
    [redRows, redCols] = find(K(:,:,1) == 255 & K(:,:,2) == 0 & K(:,:,3) == 0);
    redCoordinates = unique([redRows, redCols], 'rows'); % 重複を排除
    assignin('base', 'redCoordinates', redCoordinates);

    % サブピクセル精度の座標を取得
    subpixelRedCoordinates = [];
    
    for i = 1:size(redCoordinates, 1)
        % ピクセル近傍のサブピクセル精度の値を補間
        row = redCoordinates(i, 1);
        col = redCoordinates(i, 2);
        
        % 境界チェックを追加
        if row < size(K, 1) && col < size(K, 2)
            % バイリニア補間を使用してサブピクセル位置を求める
            [xSubpixel, ySubpixel] = subpixelPosition(K(:,:,1), row, col);
            newCoordinate = [xSubpixel, ySubpixel];
        else
            % 境界外の場合はそのままの座標を使用
            newCoordinate = [row, col];
        end

        % 新しい座標を追加
        subpixelRedCoordinates = [subpixelRedCoordinates; newCoordinate];
        % 新しい座標を表示
        fprintf('Subpixel Red Coordinate %d: (%.2f, %.2f)\n', i, newCoordinate(1), newCoordinate(2));
    end

    subpixelRedCoordinates = subpixelRedCoordinates(:, [2, 1]); % 1列目と2列目を入れ替える

    % ワークスペースに補間結果を保存
    assignin('base', 'subpixelRedCoordinates', subpixelRedCoordinates);
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
        denominatorX = (f10 - f00 + f11 - f01);
        denominatorY = (f01 - f00 + f11 - f10);
        if denominatorX ~= 0
            xSubpixel = row + (f10 - f00) / denominatorX;
        else
            xSubpixel = row;
        end
        if denominatorY ~= 0
            ySubpixel = col + (f01 - f00) / denominatorY;
        else
            ySubpixel = col;
        end
    else
        xSubpixel = row;
        ySubpixel = col;
    end
end

