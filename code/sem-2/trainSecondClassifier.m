function [l,a,p] = trainSecondClassifier(rearHogs, sideHogs)
    load(rearHogs);
    rearCarHogs = carHogs;
    load(sideHogs);
    sideCarHogs = carHogs;
    
    rearModel = trainLibSVMFromHogs( rearHogs );
    sideModel = trainLibSVMFromHogs( sideHogs );
    
    labels = [ones(size(rearCarHogs,1),1)];
    [lR2R, aR2R, pR2R] = svmpredict(labels, rearCarHogs, rearModel, '-b 1');
    [lR2S, aR2S, pR2S] = svmpredict(labels, rearCarHogs, sideModel, '-b 1');
    
    labels = [ones(size(sideCarHogs,1),1)];    
    [lS2R, aS2R, pS2R] = svmpredict(labels, sideCarHogs, rearModel, '-b 1');
    [lS2S, aS2S, pS2S] = svmpredict(labels, sideCarHogs, sideModel, '-b 1');
    
    labels = [ones(size(notCarHogs,1),1)];
    [lN2R, aN2R, pN2R] = svmpredict(labels, notCarHogs, rearModel, '-b 1');
    [lN2S, aN2S, pN2S] = svmpredict(labels, notCarHogs, sideModel, '-b 1');
    
    %instances = [rearCarHogs; sideCarHogs; nonCarHogs];
    
    rearPredictions = [pR2R(:,1), pR2S(:,1)];
    sidePredictions = [pS2R(:,1), pS2S(:,1)];
    bgPredictions   = [pN2R(:,1), pN2S(:,1)];
    
    instances = [rearPredictions; sidePredictions; bgPredictions];
    
    labels = [ones(size(rearCarHogs,1),1); 
              2 * ones(size(sideCarHogs,1),1);
              3 * ones(size(notCarHogs, 1), 1)];
        
          
      rearPredictions
      size(labels)
      size(instances)
     model3class = svmtrain(labels, instances, '-b 1');
     [l, a, p] = svmpredict(labels, instances, model3class, '-b 1');
    
    save('models.mat', 'rearModel', 'sideModel', 'model3class');

end