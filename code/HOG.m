function [ hog ] = HOG(gradients, orientations, hCells, wCells)
% img = path to the image
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  %  hCells = 16;%nbr of cells on each dimension
  %  wCells = 8;
    blockSize = 2; %3 * 3 - best
  %  cellH = 8; %6 * 6 - best
  %  cellW = 8;
    nbrBins = 9;
    degreesRange = 180;

    magnit = gradients;%gb_CS; %magnitude
    or = orientations;%orC; %orientation 0 - 180 degrees
    
    %%orientation binning
    [h, w] = size(magnit);
    cellH = floor(h / hCells);
    cellW = floor(w / wCells);
    hist = zeros(hCells, wCells, nbrBins);
    iidx = 1;
    i = 1;
    while i <= h 
       incH = inc(cellH, h, hCells, iidx);
       stepH = cellH + incH;
       mxH = min(h, i + stepH - 1);
       j = 1;
       jidx = 1;
       while j <= w
            incW = inc(cellW, w, wCells, jidx);
            stepW = cellW + incW;
            mxW = min(w, j + stepW - 1);
            cellOr = or(i : mxH, j : mxW); 
            cellOr = cellOr(:);
            cellMagnit = magnit(i : mxH, j : mxW);
            cellMagnit = cellMagnit(:);
            bin = ceil(cellOr / (degreesRange / nbrBins));
            cellHist = zeros(1, nbrBins);
            bin(bin == 0) = 1; %%if or == 0, it will be the first bin
            for k = 1 :  length(bin)
                cellHist(bin(k)) = cellHist(bin(k)) + cellMagnit(k);
            end
            hist(iidx, jidx, :) = cellHist;
            jidx = jidx + 1;
            j = j + stepW;
        end
        
        i = i + stepH;
        iidx = iidx + 1;
    end
    
    %%normalize cells
    [h, w, d] = size(hist);
    hog = [];
    for i = 1 : h - blockSize + 1
        for j = 1 : w - blockSize + 1
            blockHist = hist(i : i + blockSize - 1, j : j + blockSize - 1, :);
            rz = blockHist(:);
            rz = rz / (norm(rz) + eps);
            hog = [hog, rz'];
        end
    end
    
end

function ret = inc(cellH, h, hCells, i)
    if cellH * hCells < h
        if i <= h - hCells *cellH
            ret = 1;
        else
            ret = 0;
        end
    else
        ret = 0;
    end     
end
