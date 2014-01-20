function hogs = computeHOGs(images, hCells, wCells)
images
hogs = [];

for i = 1:length(images)
    I = imread(images{i});
    hog = applyHog(I, hCells, wCells);
    hogs = [hogs; hog];
end
end