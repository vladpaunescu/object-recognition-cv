function classify3Classes(rearCarDir, sideCarDir, notCarDir, modelFile, rearHogs, sideHogs)

    load(rearHogs);
    rearCarHogs = carHogs;
    load(sideHogs);
    sideCarHogs = carHogs;
    
    rearCarImgs = readFiles(rearCarDir);
    sideCarImgs = readFiles(sideCarDir);
    notCarImgs = readFiles(notCarDir);
    
    interactive = false;
    
    load(modelFile); % 'rearModel', 'sideModel', 'model3class'
    
    

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
        

     [predictions, a, probs] = svmpredict(labels, instances, model3class, '-b 1');
     
     rearCarsNum = size(rearCarHogs,1);
     sideCarsNum = size(sideCarHogs, 1);
     notCarsNum = size(notCarHogs, 1);
     
     predict(rearCarImgs, predictions(1:rearCarsNum, :), 1);
     predict(sideCarImgs, predictions(rearCarsNum + 1: rearCarsNum + sideCarsNum,  :), 2);
     predict(notCarImgs, predictions(rearCarsNum + sideCarsNum + 1: end,  :), 3);
            
end
       

function predict(imgs, predictions, correctLabel)
    correct = 0;
    figure    
    for i = 1:size(predictions,1)
       disp (predictions(i));
       disp(imgs{i});
       I = imread(imgs{i});
       
       [h, w, d] = size(I);
       
       imshow(I);
       hold on;
       if correctLabel == 1
          text(10, 20, 'CAR REAR - REAL', 'fontSize',12,'fontWeight','bold', 'color', 'blue');
       elseif correctLabel == 2
          text(10, 20, 'CAR SIDE - REAL', 'fontSize',12,'fontWeight','bold', 'color', 'blue');
       else
          text(10, 20, 'NOT CAR - REAL', 'fontSize',12,'fontWeight','bold', 'color', 'blue');
       end
      	  
       color = 'green';
       if predictions(i) ~= correctLabel
            color = 'red';
       end
       
       if predictions(i) == 1
          text(10, 45, 'CAR REAR - PREDICTED', 'fontSize',12,'fontWeight','bold', 'color', color);
       elseif predictions(i) == 2
          text(10, 45, 'CAR SIDE - PREDICTED', 'fontSize',12,'fontWeight','bold', 'color', color);
       else
          text(10, 45, 'NOT CAR - PREDICTED', 'fontSize',12,'fontWeight','bold', 'color', color);
       end
       
       hold off
       
        f=getframe(gca)
        [X, map] = frame2im(f);
        output = sprintf('result_%d_%d.jpg', correctLabel, i);
        imwrite(X,output);
       
     
    end

end

function pred = classifyImage(svmModel, hog)
    pred = svmclassify(svmModel, hog, 'Showplot',false);
    
end
