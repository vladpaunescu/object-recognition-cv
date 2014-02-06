function testCarDetection()
    matDir = 'mats';
    carRects = 'mats/car-rects.mat';
    carsDir = 'E:\1_Work\CV\datasets\cars_markus';
    gbsDir = 'E:\1_Work\CV\datasets\cars_markus_Gbs';
    baseDir =  'E:\1_Work\CV\datasets\results';
    
    for hCells = 3:4
        for wCells = 4:15
            trainingData = sprintf('%s/training-cars-cropped-%d-%d.mat', matDir, hCells, wCells);
            outDir = sprintf('%s/results-%d-%d', baseDir, hCells, wCells);
            detectCarsUsingGbs(gbsDir, carsDir, outDir, trainingData, carRects, hCells, wCells)
        end
    end

end 