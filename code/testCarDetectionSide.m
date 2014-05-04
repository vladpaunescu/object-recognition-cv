function testCarDetectionSide()
    matDir = 'E:\1_Work\CV\datasets\mats-serialized\mats-side';
    carRects = 'E:\1_Work\CV\datasets\mats-serialized\mats-side\car-rects.mat';
    carsDir = 'E:\1_Work\CV\datasets\sideviews-cars';
    gbsDir = 'E:\1_Work\CV\datasets\sideviews-cars-Gb';
    baseDir =  'E:\1_Work\CV\datasets\results-side';
    
   % for hCells = 5:7 %2:10
    %    for wCells = 4:15
    hCells = 5;
    wCells = 15;
            trainingData = sprintf('%s/training-cars-cropped-%d-%d.mat', matDir, hCells, wCells);
            outDir = sprintf('%s/results-%d-%d', baseDir, hCells, wCells);
            detectCarsUsingGbs(gbsDir, carsDir, outDir, trainingData, carRects, hCells, wCells)
    %    end
   % end

end 