function  computeGb(dir)
    images = readFiles(dir);
    for i = 1:length(images)
        disp(images{i});
        [pathstr, name, ext] = fileparts(images{i});
        output = sprintf('%s.mat', name);
        I = imread(images{i});
        [gb_thin_CSG, gb_thin_CS, gb_CS, orC, edgeImage, edgeComponents] = Gb_CSG(I);
        save(output, 'gb_thin_CSG', 'gb_thin_CS', 'gb_CS', 'orC', 'edgeImage', 'edgeComponents');
end