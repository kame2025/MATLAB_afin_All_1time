function [imds, ten, plot_statas] = load_photo(imageFolder, xlens, ylens, magnification, flag)
    % 画像処理後のファイルを読み込む
    filePattern = fullfile(imageFolder, '*.png');
    imageFiles = dir(filePattern);
    
    % ファイル名を取得し、数字の小さい順に並べ替える
    fileNames = {imageFiles.name}';
    [~, sortIdx] = sort(str2double(regexp(fileNames, '\d+', 'match', 'once')));
    sortedFileNames = fileNames(sortIdx);
    
    % 完全なファイルパスを作成
    fullFilePaths = fullfile(imageFolder, sortedFileNames);
    
    % 並べ替えたファイルパスでImageDatastoreを作成
    imds = imageDatastore(fullFilePaths);
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
