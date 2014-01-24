function scanImage(imagefile, trainingData)
    hCells = 4;
    wCells = 8;    
    load(trainingData); %carHogs, notCarHogs
    k = 10;
    meas = [carHogs; notCarHogs];
    groups = [ones(size(carHogs,1),1); zeros(size(notCarHogs,1),1)];
    svmModel = svmtrain(meas, groups);   
    
    I = imread(imagefile);
    [h, w, d] = size(I);
    h, w
   
    marked = zeros(h,w);     
    [gb_thin_CSG, gb_thin_CS, gb_CS, orC, edgeImage, edgeComponents] = Gb_CSG(I);
    figure
    imshow(I);
    hold on;
    for scale = 1:3
        disp(scale)
        any(marked(:))
        marked = sweepImageAtScale(I, marked, svmModel, h, w, scale, gb_thin_CSG, orC, hCells, wCells);
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
            %if ~any(patch(:))
               % Determine if any array elements are nonzero        
                pred = scanPatch(svmModel, i, j, imgHeight, imgWidth, gb_thin_CSG, orC, hCells, wCells);
                if pred == 1
                    marked(i:i+imgHeight, j: j + imgWidth) = 1;
                    outputStr = sprintf('Prediction at %d , %d\n', i, j);
                    disp(outputStr);
                    rectangle ('Position', [j, i, imgWidth, imgHeight], 'EdgeColor', 'g');                
                end
            %end
        end
    end         
end

function pred = scanPatch(svmModel, i, j, imgHeight, imgWidth, gb_thin_CSG, orC, hCells, wCells)
    gbPatch = gb_thin_CSG(i:i+imgHeight, j: j + imgWidth);
    gbPatch = orC(i:i+imgHeight, j: j + imgWidth);
    hog = HOG(gbPatch, gbPatch,hCells,wCells);
    pred = svmclassify(svmModel, hog, 'Showplot',false);
    
end
