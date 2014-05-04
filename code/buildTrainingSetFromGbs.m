function buildTrainingSetFromGbs(carGbsDir, notCarGbsDir)
    % buildTrainingSet('E:\1_Work\CV\datasets\cars_cropped', 'E:\1_Work\CV\datasets\neg')
    [carGbs, notCarGbs] =  listImages(carGbsDir, notCarGbsDir);
   % for hCells = 2:10
    %    for wCells = 13:15 % 4:12
    hCells = 5;
    wCells = 15;
            carHogs = computeHogsFromGbs(carGbs, hCells, wCells);
            notCarHogs = computeHogsFromGbs(notCarGbs, hCells, wCells);
            output = sprintf('training-cars-cropped-%d-%d.mat', hCells, wCells);
            disp(output);
            save(output, 'carHogs', 'notCarHogs');
     %   end
%    end
end