function [registered] = transformation_matrix(imageFolder, J2, imds, plot_statas, mp, flag)
    while hasdata(imds)
        [img, info] = read(imds);
        
        % 座標を代入
        fp1 = plot_statas{1};  % インデックス調整
        assignin('base', 'fp1', fp1);
        tform = fitgeotrans(mp, fp1, 'projective');
        registered = imwarp(J2, tform);
        if flag
            % ファイル名に注意して保存
            [~, name, ext] = fileparts(info.Filename);
            outputFile = fullfile(imageFolder, sprintf('afin_%s%s', name, ext));
            imwrite(registered, outputFile);
            5
        end
    end
end