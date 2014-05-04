 computeGb('E:\1_Work\CV\datasets\sideviews-cars')
  buildTrainingSetFromGbs('E:\1_Work\CV\datasets\sideviews-cars-Gb', 'E:\1_Work\CV\datasets\neg_small_Gbs');
  
  [l,a,p]= trainSecondClassifier('E:\1_Work\CV\datasets\mats-serialized\libsvm-selection\training-cars-cropped-4-10-back.mat', 'E:\1_Work\CV\datasets\mats-serialized\libsvm-selection\training-cars-cropped-5-15-side.mat')