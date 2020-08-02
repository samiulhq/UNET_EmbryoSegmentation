%clear all;

%load network_new.mat
m=128;
n=128;
filenames=dir('Output\testimg\*.tiff');
for i=1:length(filenames)
    Ifull=imread(strcat('Output\testimg\',filenames(i).name));
    I=imresize(Ifull,[m n]);
    p=net.predict(I);
    result=p(:,:,1);
    %result(find(result<1))=0;
    result(result>=0.95)=1;
    result(result<0.95)=0;
    %result=255*result;
    I2 = imfill(result);
    result=imresize(result,[1024 1024]);
    I2=imresize(I2,[1024 1024]);
    
    CC = bwconncomp(I2);
    if CC.NumObjects>1
     rp = regionprops(CC, 'Area', 'PixelIdxList');
     areas=zeros(1,CC.NumObjects);
     for i=1:CC.NumObjects
         areas(i)=rp(i).Area;
     end
     [~, idx]=max(areas);
     Itmp=zeros(size(I2));
     Itmp(CC.PixelIdxList{idx})=1;
     I2=Itmp;    
    else
     Itmp=zeros(size(I2));
     Itmp(CC.PixelIdxList{1})=1;
     I2=Itmp;
    end
    figure;
    subplot(1,2,1);
    imshow(result);
    subplot(1,2,2);
    imshow(I2);
     close all;
    imwrite(uint8(255*I2),strcat('Output\testresults\',filenames(i).name));
    boundary=boundarymask(I2);
    figure; 
    
    imshow(Ifull);hold on;
    
    [idx]=find(boundary==1);    
    [idx]=find(I2==1);
    Ifull(idx)=0;
    Ir=Ifull;
    Ir(idx)=255;
    rgbimg=cat(3,Ir,Ifull,Ifull);      
    imshow(rgbimg);   
    alpha(0.5);
    close all;
   
end