function [redCoordinates] = getCoordinates(K)
    % 赤色の座標を取得
    [redRows, redCols] = find(K(:,:,1) == 255 & K(:,:,2) == 0 & K(:,:,3) == 0);

    % 結果を表示
    redCoordinates = [redRows, redCols];
end
