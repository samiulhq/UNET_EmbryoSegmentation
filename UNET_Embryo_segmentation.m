dbpath = 'L:\Sweetpotato Classification\DGRP_Test';

imagedir = 'Output/trainingimg'; % Directory that holds the images and labels
labeldir = 'Output/traininglabel';

imagepath = [dbpath '/' imagedir]; % The entire path to the images and labels
labelpath = [dbpath '/' labeldir];

labelIDs = [255, 0]; % Setup the datasets to be used by UNET
className = ["embryo", "background"];
imds = imageDatastore(imagepath);
pxds = pixelLabelDatastore(labelpath, className, labelIDs);
ds = pixelLabelImageDatastore(imds, pxds); % Create data source for training a semantic segmentation network.
m=128;
n=128;
imageSize = [m, n, 1]; % Parameters for the UNET
numClasses = 2;filtersize = 3;

un = unetLayers(imageSize, numClasses, ... % Create the UNET object
           'FilterSize', filtersize);
                  
options = trainingOptions('adam', ...
                          'Plots', 'training-progress', ...
                          'MiniBatchSize', 16, ...
                          'MaxEpochs', 50);
                      
net = trainNetwork(ds, un, options); % Train the UNET network
save('unte_projected_sum','net');