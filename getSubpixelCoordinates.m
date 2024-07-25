function [subpixelRedCoordinates] = getSubpixelCoordinates(K, flag)
    % 赤色のピクセル座標を取得
    [redRows, redCols] = find(K(:,:,1) == 255 & K(:,:,2) == 0 & K(:,:,3) == 0);
    redCoordinates = [redRows, redCols];
    
    % サブピクセル精度の座標を取得
    subpixelRedCoordinates = zeros(size(redCoordinates));
    
    for i = 1:length(redRows)
        % ピクセル近傍のサブピクセル精度の値を補間
        row = redRows(i);
        col = redCols(i);
        
        % 境界チェックを追加
        if row < size(K, 1) && col < size(K, 2)
            % バイリニア補間を使用してサブピクセル位置を求める
            [xSubpixel, ySubpixel] = subpixelPosition(K(:,:,1), row, col);
            subpixelRedCoordinates(i, :) = [xSubpixel, ySubpixel];
        else
            % 境界外の場合はそのままの座標を使用
            subpixelRedCoordinates(i, :) = [row, col];
        end
    end

    % replacement関数を使用して入れ替え
    subpixelRedCoordinates = replacement(subpixelRedCoordinates, flag);
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

function subpixelRedCoordinates = replacement(subpixelRedCoordinates, flag)
    % 全ての座標の1列目と2列目を入れ替える
    subpixelRedCoordinates = subpixelRedCoordinates(:, [2, 1]);
    
    % 配列のサイズが少なくとも3行あることを確認
    if size(subpixelRedCoordinates, 1) < 3
        warning('subpixelRedCoordinates の行数が少なすぎます。処理をスキップします。');
        return;
    end
    
    % 行の入れ替え
    if flag
        if size(subpixelRedCoordinates, 1) >= 3
            sub = subpixelRedCoordinates(3,:);
            subpixelRedCoordinates(3,:) = subpixelRedCoordinates(2,:);
            subpixelRedCoordinates(2,:) = sub;
        end
    else
        sub = []; % subの初期化
        for i = 1:size(subpixelRedCoordinates, 1)
            if subpixelRedCoordinates(i, 1) > 4000
                sub = [sub; subpixelRedCoordinates(i, :)]; 
                assignin('base', 'sub', sub);
            end
            if 2 < i && i < size(subpixelRedCoordinates, 1) - 2 
                correct = i + 2;
                subpixelRedCoordinates(correct, :) = subpixelRedCoordinates(i, :);
%             elseif size(subpixelRedCoordinates, 1) - 2 < i && size(sub, 1) >= 2
%                 subpixelRedCoordinates(3, :) = sub(1, :);
%                 subpixelRedCoordinates(4, :) = sub(2, :);
            end
        end
    end
end
