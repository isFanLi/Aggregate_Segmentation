%% YOLO 图像预处理 (中心裁剪版)
clear; clc;

% --- 参数设置 ---
inputDir = 'Image_Unprocessed'; % 输入文件夹
outputDir = 'Image_Processed';   % 输出文件夹
targetSize = 640;                % 目标尺寸

if ~exist(outputDir, 'dir'), mkdir(outputDir); end

imgFiles = dir(fullfile(inputDir, '*.*'));
imgFiles = imgFiles(contains({imgFiles.name}, {'.png', '.jpg', '.jpeg', '.bmp'}));

count = 1; 
for k = 1:length(imgFiles)
    try
        % 1. 读取原始图片
        img = imread(fullfile(inputDir, imgFiles(k).name));
        [h, w, c] = size(img);
        
        % 2. 核心逻辑：以短边为基准取中心正方形 (中心裁剪)
        sz = min(h, w); % 提取短边长度
        rowStart = floor((h - sz) / 2) + 1;
        colStart = floor((w - sz) / 2) + 1;
        % 直接切出中间最精华的正方形部分
        imgSquare = img(rowStart : rowStart + sz - 1, colStart : colStart + sz - 1, :);
        
        % 3. 灰度化
        if size(imgSquare, 3) == 3
            imgGray = rgb2gray(imgSquare);
        else
            imgGray = imgSquare;
        end
        
        % 4. 中值滤波 (去噪)
        imgFiltered = medfilt2(imgGray, [3 3]);
        
        % 5. 直方图均衡化 (让骨料边缘更清晰)
        imgEq = histeq(imgFiltered);
        
        % 6. 缩放到 640*640
        finalImg = imresize(imgEq, [targetSize targetSize]);
        
        % 7. 重新编号输出
        outputName = sprintf('%04d.png', count);
        imwrite(finalImg, fullfile(outputDir, outputName));
        
        fprintf('处理成功: %s -> %s (原始尺寸: %dx%d)\n', imgFiles(k).name, outputName, w, h);
        count = count + 1;
        
    catch ME
        fprintf('跳过错误文件 %s: %s\n', imgFiles(k).name, ME.message);
    end
end
fprintf('--- 全部搞定！共处理 %d 张精华图片 ---\n', count-1);