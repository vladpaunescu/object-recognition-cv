function [skinImgs, notSkinImgs] =  listImages(skinDir, notSkinDir)
    skinImgs = readFiles(skinDir);
    notSkinImgs = readFiles(notSkinDir);
end
