function detectCars(dir, trainingData)
    %  detectCars('E:\1_Work\CV\datasets\cars_markus', 'training-cars-cropped-4-8.mat')
    hCells = 4;
    wCells = 8;    
    load(trainingData); %carHogs, notCarHogs
    meas = [carHogs; notCarHogs];
    groups = [ones(size(carHogs,1),1); zeros(size(notCarHogs,1),1)];
    svmModel = svmtrain(meas, groups);   
    
    figure
    images = readFiles(dir);
    for i = 1:length(images)
        disp(images{i});
        output = sprintf('result_%d.jpg', i);
        
        if exist(output, 'file')
            disp(sprintf('File %s exists', output));
            continue;
        end
        
        [pathstr, name, ext] = fileparts(images{i});
        I = imread(images{i});
        [h, w, d] = size(I);
        w,h  
   
        marked = zeros(h,w);     
        [gb_thin_CSG, gb_thin_CS, gb_CS, orC, edgeImage, edgeComponents] = Gb_CSG(I);
        imshow(I);
        hold on;
        for scale = 1:3
            disp(scale)
            marked = marked + sweepImageAtScale(I, marked, svmModel, h, w, scale, gb_thin_CSG, orC, hCells, wCells);
        end
        if any(marked(:))
            [topRow, bottomRow, leftCol, rightCol] = determineBoundingBox(marked, 0.3);
            rectangle ('Position', [leftCol, topRow, rightCol - leftCol + 1, bottomRow - topRow + 1], 'EdgeColor', 'g');       
        end
        
        hold off
    
        f=getframe(gca)
        [X, map] = frame2im(f);
        imwrite(X,output);
 
    end
       
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
    
    while topRow < r && marked(bottomRow, maxJ) >= 0.3 * maxVal
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
