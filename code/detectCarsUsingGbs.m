function detectCarsUsingGbs(gbsDir, carsDir, outDir, trainingData, carRects, hCells, wCells)
    %  detectCars('E:\1_Work\CV\datasets\cars_markus', 'training-cars-cropped-4-8.mat')
    imgs = readFiles(carsDir);
    mkdir(outDir);
    
    load(carRects); %carRects, images
    load(trainingData); %carHogs, notCarHogs
    carsNum = size(carHogs, 1);
    notCarsNum = size(notCarHogs, 1);
    
    trainPercent = 0.7;
    trainCarsNum = floor(trainPercent * carsNum);
    trainNotCarsNum = floor(trainPercent * notCarsNum);
    
    trainCarHogs = carHogs(1:trainCarsNum, :);
    trainNotCarHogs = notCarHogs(1:trainNotCarsNum, :);
    
    testCarHogs = carHogs(trainCarsNum + 1 : end, :);
    testNotCarHogs = notCarHogs(trainNotCarsNum + 1, :);

    meas = [trainCarHogs; trainNotCarHogs];
    groups = [ones(size(trainCarHogs,1),1); zeros(size(trainNotCarHogs,1),1)];
    svmModel = svmtrain(meas, groups); 
    
    predictedCarRects = zeros(length(images), 4);
    areas = zeros(length(images), 3);
 
    
    figure
    for i = trainCarsNum + 1 : length(images)
        disp(images{i});
        output = sprintf('%s/result_%d.jpg', outDir, i);
        
        [pathstr, name, ext] = fileparts(images{i});
        gbFile = sprintf('%s/%s.mat',gbsDir, name);
        disp(gbFile);
        load(gbFile);
        
        
        if exist(output, 'file')
            disp(sprintf('File %s exists', output));
            continue;
        end
        
        I = imread(images{i});
        [h, w, d] = size(I);
        w,h  
   
        marked = zeros(h,w);     
        imshow(I);
        hold on;
        for scale = 1:3
            disp(scale)
            marked = marked + sweepImageAtScale(I, marked, svmModel, h, w, scale, gb_thin_CSG, orC, hCells, wCells);
        end
        if any(marked(:))
            [topRow, bottomRow, leftCol, rightCol] = determineBoundingBox(marked, 0.3);
            rectangle ('Position', [leftCol, topRow, rightCol - leftCol + 1, bottomRow - topRow + 1],'EdgeColor', 'g');
            gtTopRow = carRects(i,1);
            gtBottomRow = carRects(i,2);
            gtLeftCol = carRects(i,3);
            gtRightCol = carRects(i,4);
            rectangle ('Position', [gtLeftCol, gtTopRow, gtRightCol - gtLeftCol + 1, gtBottomRow - gtTopRow + 1],'EdgeColor', 'blue');        
            predictedCarRects(i,:) = [topRow, bottomRow, leftCol, rightCol];
            [fractionOverlap, intersectionArea, unionArea] = determmineOverlap(carRects(i,:), predictedCarRects(i,:));
            areas(i,:) = [fractionOverlap, intersectionArea, unionArea];
            msg = sprintf('Overlap %4.2f %%', fractionOverlap * 100);
            text(10, 20, msg, 'fontSize',18,'fontWeight','bold', 'color', 'green');
        else 
            gtTopRow = carRects(i,1);
            gtBottomRow = carRects(i,2);
            gtLeftCol = carRects(i,3);
            gtRightCol = carRects(i,4);
            rectangle ('Position', [gtLeftCol, gtTopRow, gtRightCol - gtLeftCol + 1, gtBottomRow - gtTopRow + 1],'EdgeColor', 'blue');       
            [fractionOverlap, intersectionArea, unionArea] = determmineOverlap(carRects(i,:), [0,0,0,0]);
            areas(i,:) = [fractionOverlap, intersectionArea, unionArea];
            msg = sprintf('Overlap %4.2f %%', fractionOverlap * 100);
            text(10, 20, msg, 'fontSize',18,'fontWeight','bold', 'color', 'green');
        end
        
        hold off
    
        f=getframe(gca)
        [X, map] = frame2im(f);
        imwrite(X,output); 
    end
    predictedCarRectsFile = sprintf('E:/1_Work/CV/datasets/mats-serialized/mats-side/predicted-car-rects-%d-%d.mat', hCells, wCells);
    save(predictedCarRectsFile, 'areas', 'predictedCarRects', 'carRects', 'images');
       
end

function [fractionOverlap, intersectionArea, unionArea] = determmineOverlap(carRect, predictedCarRect)
    rect = zeros(1,4);
    rect(1) = max(carRect(1), predictedCarRect(1));
    rect(2) = min(carRect(2), predictedCarRect(2));
    
    rect(3) = max(carRect(3), predictedCarRect(3));
    rect(4) = min(carRect(4), predictedCarRect(4));
    
    intersectionArea = rectArea(rect);
    a1 = rectArea(carRect);
    a2 = rectArea(predictedCarRect);
    unionArea = a1 + a2 - intersectionArea;
    fractionOverlap = intersectionArea / unionArea;  
end

function a = rectArea(rect)
    a = (rect(2) - rect(1)) * (rect(4) - rect(3)); 
end
    

function [topRow, bottomRow, leftCol, rightCol] = determineBoundingBox(marked, thresh)
    [row,col] = find(marked == max(marked(:)));
    outputStr = sprintf('Maximum at (r,c) = %d %d\n', row, col);
    disp(outputStr);
    maxI = row(1,1);
    maxJ = col(1,1);
    maxVal = max(marked(:));
    [r, c] = size(marked);
    
    topRow = maxI; bottomRow = maxI;
    leftCol = maxJ; rightCol = maxJ;
    
    while topRow > 1 && marked(topRow, maxJ) >= 0.3 * maxVal
        topRow = topRow - 1;
    end
    
    while topRow < r && marked(bottomRow, maxJ) >= 0.3 * maxVal && bottomRow < r
        bottomRow = bottomRow + 1;
    end
    
    while leftCol > 1 &&marked(maxI, leftCol) >= 0.3 * maxVal
        leftCol = leftCol - 1;
    end
    
    while rightCol < c && marked(maxI, rightCol) >= 0.3 * maxVal
        rightCol = rightCol + 1;
    end
end


function marked = sweepImageAtScale(I, marked, svmModel, h, w, scale, gb_thin_CSG, orC, hCells, wCells)
    imgHeight = floor( h / scale);
    imgWidth = floor(w / scale);
    outputString = sprintf('Scanning at size %d x %d\n', imgHeight, imgWidth);
    disp(outputString);
    
    for i = 1 : 10: h-imgHeight
        for j = 1:10: w - imgWidth
            patch = marked(i:i+imgHeight, j: j + imgWidth);
               % Determine if any array elements are nonzero        
                pred = scanPatch(svmModel, i, j, imgHeight, imgWidth, gb_thin_CSG, orC, hCells, wCells);
                if pred == 1
                    marked(i:i+imgHeight, j: j + imgWidth) = marked(i:i+imgHeight, j: j + imgWidth) +1;
                    outputStr = sprintf('Prediction at %d , %d\n', i, j);
                    disp(outputStr);
                             
                end
        end
    end         
end

function pred = scanPatch(svmModel, i, j, imgHeight, imgWidth, gb_thin_CSG, orC, hCells, wCells)
    gbPatch = gb_thin_CSG(i:i+imgHeight, j: j + imgWidth);
    gbPatch = orC(i:i+imgHeight, j: j + imgWidth);
    hog = HOG(gbPatch, gbPatch,hCells,wCells);
    pred = svmclassify(svmModel, hog, 'Showplot',false);
    
end
