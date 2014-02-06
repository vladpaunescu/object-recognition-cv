function carRects = cropImages(dir, outDir)
    mkdir(outDir);
    images = readFiles(dir);
    carRects = zeros(length(images), 4);
    for i = 1:length(images)
        disp(images{i});
        [pathstr,name,ext] = fileparts(images{i});
        I = imread(images{i});
        [crop, row, col] = cropImage(I);
        imwrite(crop, strcat(outDir, '\', name, ext));
        carRects(i,:) = [row',col']
    end
    save('car-rects.mat', 'carRects', 'images');
end

function [croppedImg, y, x] = cropImage(img)
    imshow(img);
    [x,y] = ginput(2);
    x = floor(x);
    y = floor(y);   
    croppedImg = img(y(1):y(2), x(1):x(2), :);  
end