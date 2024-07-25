% function [registered] = transformation_matrix(imageFolder, J2, imds, plot_statas, mp)
%     while hasdata(imds)
%         [img, info] = read(imds);
%         
%         % 座標を代入
%         fp1 = plot_statas{1};  % インデックス調整
%         
%         tform = fitgeotrans(mp, fp1, 'projective');
%         registered = imwarp(J2, tform);
%         
%         % ファイル名に注意して保存
%         [~, name, ext] = fileparts(info.Filename);
%         outputFile = fullfile(imageFolder, sprintf('afin_%s%s', name, ext));
%         imwrite(registered, outputFile);
%     end
% end

function [registered] = transformation_matrix(imageFolder, J2, imds, plot_statas, mp)
    % 一時ファイル保存用のディレクトリ
    tempDir = fullfile(tempdir, 'temp_registered_images');
    if ~exist(tempDir, 'dir')
        mkdir(tempDir);
    end
    
    % 全ファイルを一時ファイルに書き込む
    while hasdata(imds)
        [img, info] = read(imds);
        
        % 座標を代入
        fp1 = plot_statas{1};  % インデックス調整
        
        tform = fitgeotrans(mp, fp1, 'projective');
        registered = imwarp(J2, tform);
        
        % 一時ファイルに保存
        [~, name, ext] = fileparts(info.Filename);
        tempFile = fullfile(tempDir, sprintf('afin_%s%s', name, ext));
        imwrite(registered, tempFile);
    end
    
    % 一時ファイルから最終保存先にコピー
    tempFiles = dir(fullfile(tempDir, '*.png'));
    parfor i = 1:length(tempFiles)
        tempFile = fullfile(tempDir, tempFiles(i).name);
        finalFile = fullfile(imageFolder, tempFiles(i).name);
        copyfile(tempFile, finalFile);
    end
    
    % 一時ディレクトリを削除
    rmdir(tempDir, 's');
end

