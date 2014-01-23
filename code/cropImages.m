function cropImages(dir, outDir)
    mkdir(outDir);
    images = readFiles(dir);
    for i = 1:length(images)
        disp(images{i});
        [pathstr,name,ext] = fileparts(images{i});
        I = imread(images{i});
        crop = cropImage(I);
        imwrite(crop, strcat(outDir, '\', name, ext));
       
    end
end

function croppedImg = cropImage(img)
    imshow(img);
    [x,y] = ginput(2);
    x = floor(x);
    y = floor(y);   
    croppedImg = img(y(1):y(2), x(1):x(2), :);  
end