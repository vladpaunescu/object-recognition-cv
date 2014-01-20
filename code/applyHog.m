function hog = applyHog(I, hCells, wCells)
    %I = imread(filename);
    [gb_thin_CSG, gb_thin_CS, gb_CS, orC, edgeImage, edgeComponents] = Gb_CSG(I);
    hog = HOG(gb_thin_CSG, orC,hCells,wCells); 
    
end