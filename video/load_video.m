function [imds, ten, plot_statas] = load_photo(imageFolder, xlens, ylens, magnification, flag)
    % フレームごとの処理に対応したファイルパターンを設定します。
    % ファイル名はフレーム番号を考慮して動的に変更します。

    % 動画フレームごとに保存するために動画特有の処理に対応
    % 元の処理と同様に座標情報をフレームに適用

    % フレーム用の画像処理後のファイルを読み込む
    filePattern = fullfile(imageFolder, '*.png');  % 動画の場合、各フレームごとの処理が必要
    imageFiles = dir(filePattern);
    
    % 以下の処理はそのまま適用できます。
    % 動画フレームごとの処理フローを踏襲するように修正します。
    
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
