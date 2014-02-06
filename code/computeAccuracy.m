function [results, x, y, z] = computeAccuracy()
    results = [];
    [x,y] = meshgrid(2:10, 4:15);
    z = zeros(size(x,1), size(x,2));

    for hCells = 2:10
        for wCells = 4:15
            trainingData = sprintf('training-cars-cropped-%d-%d.mat', hCells, wCells);
            disp(trainingData);
            [accuracy, confusionMatrix] = classify(trainingData);
            results = [results; [hCells, wCells, accuracy, confusionMatrix(:)']];
            i = wCells - 4 + 1;
            j = hCells - 2 + 1;
            z(i,j) = accuracy;
        end
    end    
end