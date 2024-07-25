function ten_main(baseDir, xlens, ylens, magnification, IMG, pix, pix2, tate, yoko)
    plot_statas = {};  % ループの外で初期化

    a = 0;
    b = 0;
    count = 0;
    for x = pix2:pix:tate
        if a ~= xlens
            for y = pix2:pix:yoko
                if a == 0 && b == 0
                    IMG(x, y, 1) = 255; % (縦,横,1 or 2 or 3)
                end
                if x+1 <= tate && y+1 <= yoko
                    if b == ylens
                        IMG(x, y, 1) = 255; % (縦,横,1 or 2 or 3)
                        count = 1;
                    end
                    b = b + 1;
                    c = b;
                end
                if count == 1
                    break
                end
            end
            b = 0;
            a = a + 1;
        elseif a == xlens
            count = 0;
            for y = pix2:pix:yoko
                if b == 0
                    IMG(x, y, 1) = 255; % (縦,横,1 or 2 or 3)
                end
                if x+1 <= tate && y+1 <= yoko
                    if b == ylens
                        IMG(x, y, 1) = 255; % (縦,横,1 or 2 or 3)
                        count = 1;
                    end
                    b = b + 1;
                end
                if count == 1
                    break
                end
            end
        end
    end
    a

    [subpixelRedCoordinates] = getSubpixelCoordinates(IMG);

    % 拡大後の座標を計算
    scaleFactor = magnification;
    newSubpixelRedCoordinates = subpixelRedCoordinates * scaleFactor;

    % 画像を保存
    L = imresize(IMG, magnification);   % 23の時333.91に対し、23.3626の時は328.73のため、23.3626似合わせようとすると、0.984倍する
    L1 = imcrop(L, [0 0 4320 7680]); % ↑1.007は縦がいい感じ(a=333c=187の時) 1.02
    imwrite(L1, fullfile(baseDir, sprintf('%d_%d_%.5f.png', xlens, ylens, magnification)));

    plot_statas{end+1} = newSubpixelRedCoordinates;
    disp('Red Subpixel Coordinates:');
    disp(newSubpixelRedCoordinates);

    % 座標を保存して次のスクリプトで使用
    save(fullfile(baseDir, 'coordinates.mat'), 'plot_statas');

end
