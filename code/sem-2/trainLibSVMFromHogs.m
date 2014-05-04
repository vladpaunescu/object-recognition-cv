function model = trainLibSVMFromHogs( trainingData )

%  matDir = 'E:\1_Work\CV\datasets\mats-serialized\mats-side';
%  hCells = 5;
%  wCells = 15;
%  trainingData = sprintf('%s/training-cars-cropped-%d-%d.mat', matDir, hCells, wCells);
 load(trainingData);
 labels = [ones(size(carHogs,1),1); -ones(size(notCarHogs,1),1)];
 instances = [carHogs;notCarHogs];
 model = svmtrain(labels, instances, '-b 1');
 % [l, a, p]=svmpredict(labels, instances, model, '-b 1');

 

end

