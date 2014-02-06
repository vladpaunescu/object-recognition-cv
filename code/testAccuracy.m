function testAccuracy(carDir, notCarDir, trainingData)
    [carImgs, notCarImgs] =  listImages(carDir, notCarDir);
    interactive = false;
    load(trainingData); %carHogs, notCarHogs
    carsNum = size(carHogs, 1);
    notCarsNum = size(notCarHogs, 1);
    trainPercent = 0.6;
    trainCarsNum = floor(trainPercent * carsNum);
    trainNotCarsNum = floor(trainPercent * notCarsNum);
    
    trainCarHogs = carHogs(1:trainCarsNum, :);
    trainNotCarHogs = notCarHogs(1:trainNotCarsNum, :);
    
    testCarHogs = carHogs(trainCarsNum + 1 : end, :);
    testNotCarHogs = notCarHogs(trainNotCarsNum + 1, :);

    meas = [trainCarHogs; trainNotCarHogs];
    groups = [ones(size(trainCarHogs,1),1); zeros(size(trainNotCarHogs,1),1)];
    svmModel = svmtrain(meas, groups);   
    
    %predict(svmModel, carHogs, trainCarsNum, carsNum, carImgs, interactive, 1);
    predict(svmModel, notCarHogs, trainNotCarsNum, notCarsNum, notCarImgs, interactive, 0);
end

function predict(svmModel, hogs, trainNum, totalNum, imgs, interactive, real)
    correct = 0;
    figure    
    for i = trainNum + 1 : totalNum
       hog = hogs(i,:);
       pred = classifyImage(svmModel, hog);
       disp (pred);
       disp(imgs{i});
       I = imread(imgs{i});
       
       [h, w, d] = size(I);
       
       imshow(I);
       hold on;
       text(10, 20, 'CAR - REAL', 'fontSize',18,'fontWeight','bold', 'color', 'blue');
       %text(10, 20, 'NOT CAR - REAL', 'fontSize',18,'fontWeight','bold', 'color', 'blue');    
       
       if pred == real
            text(10, 45,'CAR - PREDICTED', 'color', 'green', 'fontSize',18,'fontWeight','bold');
            %text(10, 45,'NOT CAR - PREDICTED', 'color', 'green', 'fontSize',18,'fontWeight','bold');
            correct = correct + 1;
       else
            text(10,40,'NOT CAR - PREDICTED', 'color', 'red', 'fontSize',18,'fontWeight','bold');
            %text(10,45,'CAR - PREDICTED', 'color', 'red', 'fontSize',18,'fontWeight','bold');
       end
       
       outputStr = sprintf('%d of %d', correct, totalNum - trainNum);
       text(10,70, outputStr, 'color', 'white', 'fontSize',18,'fontWeight','bold');
       
       if interactive
           k = waitforbuttonpress 
       end
       hold off
       
        f=getframe(gca)
        [X, map] = frame2im(f);
        output = sprintf('result_%d.jpg', i - trainNum);
        imwrite(X,output);
       
     
    end
    percent = correct / (totalNum - trainNum);
    disp(percent);

end

function pred = classifyImage(svmModel, hog)
    pred = svmclassify(svmModel, hog, 'Showplot',false);
    
end

