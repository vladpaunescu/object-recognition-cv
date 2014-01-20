function classify(trainingData)
    load(trainingData); %carHogs, notCarHogs
    k = 10;
    meas = [carHogs; notCarHogs];
    groups = [ones(size(carHogs,1),1); zeros(size(notCarHogs,1),1)];
   % svmStruct = svmtrain(meas, groups);
   % species = svmclassify(svmStruct,notCarHogs(5,:));
    
    kFoldCrossValidation(meas, groups, k);  
end