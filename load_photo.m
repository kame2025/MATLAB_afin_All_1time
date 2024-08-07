function [imds, ten, plot_statas] = load_photo(imageFolder, xlens, ylens, magnification, flag)

    % 画像処理後のファイルを読み込む
    filePattern = fullfile(imageFolder, '*.png');
    imageFiles = dir(filePattern);
    
    % 最初のファイルを取得
    imageFile = imageFiles(1);
    fullFilePath = fullfile(imageFolder, imageFile.name);

    % ImageDatastoreの作成
    imds = imageDatastore(fullFilePath);

    if flag
        % 生成された画像ファイル名を指定
        generated_image_filename = sprintf('%d_%d_%.5f.png', xlens, ylens, magnification);
        ten = imread(fullfile(imageFolder, generated_image_filename));

        % 座標を読み込む
        coordinatesFile = fullfile(imageFolder, 'coordinates.mat');
        load(coordinatesFile, 'plot_statas');
    else
        generated_image_filename = sprintf('second_afin_%d_%d_%.5f.png', xlens, ylens, magnification);
        ten = imread(fullfile(imageFolder, generated_image_filename));

        % 座標を読み込む
        coordinatesFile = fullfile(imageFolder, 'second_coordinates.mat');

        load(coordinatesFile, 'plot_statas');
    end
end
