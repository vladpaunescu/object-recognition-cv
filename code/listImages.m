function [skinImgs, notSkinImgs] =  listImages(skinDir, notSkinDir)
    skinImgs = readFiles(skinDir);
    notSkinImgs = readFiles(notSkinDir);
end

function imgs = readFiles(directory)
    files = dir(directory);
    imgs = cell(length(files) - 2, 1);
    for i=3:length(files)
        filename=files(i).name;
        img = strcat(directory, '/', filename);
        imgs{i-2} = img;
    end
end
