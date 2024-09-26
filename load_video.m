function [imds, ten, plot_statas] = load_video(imageFolder, xlens, ylens, magnification, flag)

    % 画像処理後のファイルを読み込む
    filePattern = fullfile(imageFolder, '*.png');
    imageFiles = dir(filePattern);
    
    if flag
        % 指定されたファイル名を作成
        targetFileName = sprintf('%d_%d_%.5f.png', xlens, ylens, magnification);
        
        % 最初のファイルを取得
        foundFile = false;
        for k = 1:length(imageFiles)
            if strcmp(imageFiles(k).name, targetFileName)
                foundFile = true;
                fullFilePath = fullfile(imageFolder, imageFiles(k).name);
                break;
            end
        end
    
        % ImageDatastoreの作成
        imds = imageDatastore(fullFilePath);
    
         % 生成された画像ファイル名を指定
        generated_image_filename = sprintf('%d_%d_%.5f.png', xlens, ylens, magnification);
        ten = imread(fullfile(imageFolder, generated_image_filename));

        % 座標を読み込む
        coordinatesFile = fullfile(imageFolder, 'coordinates.mat');
        load(coordinatesFile, 'plot_statas');
    else
        
        % 指定されたファイル名を作成
        targetFileName = sprintf('second_afin_%d_%d_%.5f.png', xlens, ylens, magnification);
        
        % 最初のファイルを取得
        foundFile = false;
        for k = 1:length(imageFiles)
            if strcmp(imageFiles(k).name, targetFileName)
                foundFile = true;
                fullFilePath = fullfile(imageFolder, imageFiles(k).name);
                break;
            end
        end
    
        % ImageDatastoreの作成
        imds = imageDatastore(fullFilePath);
    
         % 生成された画像ファイル名を指定
        generated_image_filename = sprintf('second_afin_%d_%d_%.5f.png', xlens, ylens, magnification);
        ten = imread(fullfile(imageFolder, generated_image_filename));

        % 座標を読み込む
        coordinatesFile = fullfile(imageFolder, 'second_coordinates.mat');

        load(coordinatesFile, 'plot_statas');
    end
end
