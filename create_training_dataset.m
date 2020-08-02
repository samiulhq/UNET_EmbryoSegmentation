dbpath = 'L:/Sweetpotato Classification/DGRP_Test';

imagedir = 'Output/trainingimg'; % Directory that holds the images and labels
labeldir = 'Output/traininglabel';

imagepath = [dbpath '/' imagedir]; % The entire path to the images and labels
labelpath = [dbpath '/' labeldir];
rng(123);
filenames=dir('Output/trainingimg_original/*.tiff');
m=128;
n=128;
for i=1:length(filenames)
    I=imread(strcat('Output/trainingimg_original/',filenames(i).name));
    I=imresize(I,[m n]);
    imwrite(I,strcat('Output/trainingimg/',filenames(i).name));
    I=imread(strcat('Output/traininglabel_original/',filenames(i).name));
    I=imresize(I,[m n]);
    imwrite(uint8(255*I),strcat('Output/traininglabel/',filenames(i).name));
end
ftype='.tiff';
for i=1:length(filenames)
    I=imread(strcat(imagepath,'/',filenames(i).name)); 
    r=randi([-40 40]);
    IR=imrotate(I,r,'nearest','loose');
    newfilename=filenames(i).name(1:end-length(ftype));    
    I2 = flipdim(I ,2);           %# horizontal flip
    imwrite(I2,strcat(imagepath,'/',newfilename,'_hflip','.tiff'));    
    I3 = flipdim(I ,1);           %# vertical flip
    imwrite(I3,strcat(imagepath,'/',newfilename,'_vflip','.tiff'));
    I4 = flipdim(I3,2);    %# horizontal+vertical flip
    imwrite(I4,strcat(imagepath,'/',newfilename,'_hvflip','.tiff'));    
    L=imread(strcat(labelpath,'/',filenames(i).name(1:end-length(ftype)),'.tiff'));
    L2 = flipdim(L ,2);           %# horizontal flip
    imwrite(L2,strcat(labelpath,'/',newfilename,'_hflip','.tiff'));
    L3 = flipdim(L ,1);           %# vertical flip
    imwrite(L3,strcat(labelpath,'/',newfilename,'_vflip','.tiff'));
    L4 = flipdim(L3,2);    %# horizontal+vertical flip
    imwrite(L4,strcat(labelpath,'/',newfilename,'_hvflip','.tiff'));
    LR = imrotate(L,r,'nearest','loose');           %# vertical flip
    
    IR=imresize(IR,[m n]);
    LR=imresize(LR,[m n]);
    
    imwrite(LR,strcat(labelpath,'/',newfilename,'_rotateflip','.tiff'));
    imwrite(IR,strcat(imagepath,'/',newfilename,'_rotateflip','.tiff'));
    
end