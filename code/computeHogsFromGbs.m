function hogs = computeHogsFromGbs(gbs, hCells, wCells)
    hogs = [];
    for i = 1:length(gbs)
        disp(gbs{i});
        load(gbs{i});
        hog = HOG(gb_thin_CSG, orC,hCells,wCells); 
        hogs = [hogs; hog];
    end
end