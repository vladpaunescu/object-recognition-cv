function [carHogs, notCarHogs] = buildTrainingSet(carDir, notCarDir)
    hCells = 4;
    wCells = 8;
    [carImgs, notCarImgs] =  listImages(carDir, notCarDir);
    carHogs = computeHOGs(carImgs, hCells, wCells);
    notCarHogs = computeHOGs(notCarImgs, hCells, wCells)
    
    save('training-cars-cropped-4-8.mat', 'carHogs', 'notCarHogs');
    
end
