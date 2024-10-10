function [imds, ten, plot_statas] = load_photo(imageFolder, xlens, ylens, magnification, flag)
    % 動画フレームごとに画像処理をサポートするために変更
    filePattern = fullfile(imageFolder, '*.png');
    imageFiles = dir(filePattern);
    
    if flag
        % 指定されたファイル名を作成
        targetFileName = sprintf('%d_%d_%.5f.png', xlens, ylens, magnification);
        
        % フレームの最初のファイルを取得
        for k = 1:length(imageFiles)
            if strcmp(imageFiles(k).name, targetFileName)
                fullFilePath = fullfile(imageFolder, imageFiles(k).name);
                break;
            end
        end
    
        % ImageDatastoreの作成
        imds = imageDatastore(fullFilePath);
    
        % 生成された画像ファイル名を取得
        ten = imread(fullFilePath);

        % 座標を読み込む
        coordinatesFile = fullfile(imageFolder, 'coordinates.mat');
        load(coordinatesFile, 'plot_statas');
    else
        % セカンドパス用のファイル名作成
        targetFileName = sprintf('second_afin_%d_%d_%.5f.png', xlens, ylens, magnification);
        
        % フレームの最初のファイルを取得
        for k = 1:length(imageFiles)
            if strcmp(imageFiles(k).name, targetFileName)
                fullFilePath = fullfile(imageFolder, imageFiles(k).name);
                break;
            end
        end
    
        % ImageDatastoreの作成
        imds = imageDatastore(fullFilePath);
    
        % 生成された画像ファイル名を取得
        ten = imread(fullFilePath);

        % 座標を読み込む
        coordinatesFile = fullfile(imageFolder, 'second_coordinates.mat');
        load(coordinatesFile, 'plot_statas');
    end
end
