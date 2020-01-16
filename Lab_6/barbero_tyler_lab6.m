% Tyler Barbero
% SIO135 Lab 6, May 21st, Spring 2019
% This mfile provides skeleton code to perform  image classification
% of a 7-band MODIS scene.
%
clear, clf, clc;
%
% PROBLEM 1) READ IN THE IMAGE AND LOOK AT THE BANDS
% read in and look at all 7 bands with imagesc
%

red  = uint8(load('modis1.dat'));
nir  = uint8(load('modis2.dat'));
blue  = uint8(load('modis3.dat'));
green = uint8(load('modis4.dat'));
mir1 = uint8(load('modis5.dat'));
mir2  = uint8(load('modis6.dat'));
mir3 = uint8(load('modis7.dat'));


%
% look at each band separately and an rgb image
%
figure(1)
subplot(2,4,1),imshow(histeq(red)),colorbar('horiz'),title('red');
subplot(2,4,2),imshow(histeq(nir)),colorbar('horiz'),title('nir');
subplot(2,4,3),imshow(histeq(blue)),colorbar('horiz'),title('blue');
subplot(2,4,4),imshow(histeq(green)),colorbar('horiz'),title('green');
subplot(2,4,5),imshow(histeq(mir1)),colorbar('horiz'),title('mir1');
subplot(2,4,6),imshow(histeq(mir2)),colorbar('horiz'),title('mir2');
subplot(2,4,7),imshow(histeq(mir3)),colorbar('horiz'),title('mir3');
subplot(2,4,8),imshow(cat(3,histeq(red),histeq(green),histeq(blue))),title('RBG Composite');

pause;
% PROBLEM 2) CREATE A TRAINING SET
% 5 regions: sea ice, clouds, region of dis, ice shelf, ocean
% Identify the location (row,column) of "training pixels" and assign them a "group number":
% You will need to identify at least 2 training pixels per
% group''''''''''''''''''''''''''''''''''
%

% Each line of tpix should have 3 numbers in the following format:    
%     row,col,group
%      ^   ^  ^
%
tpix=[286,113,1; ... % Group 1: Sea Ice
312,137,1; ... 
73,223,1; ...
281,376,2; ... % Group 2: Clouds
341,298,2; ...
193,339,2; ...
199,184,3; ... % Group 3: Region of Disintegration
218,195,3; ...
191,177,3; ...
121,165,4; ... % Group 4: Ice Shelf
150,263,4; ...
85,299,4; ...
232,122,5; ... % Group 5: Open Ocean
210,136,5; ...
254,117,5];

 row=tpix(:,1);   % y-value
 col=tpix(:,2);   % x-value
 group=tpix(:,3); % group number
 ngroup=max(group);

%
% From these pixels, make a training set consisting of each training pixel's band values
% "train" should have the same number of rows as the number of training pixels, and the
% same number of columns as number of bands (in the Landsat and MODIS case, 7).  
%   
 train=[];
 for i=1:length(group)
     train=[train; red(row(i),col(i)), nir(row(i),col(i)), blue(row(i),col(i))...
         ,green(row(i),col(i)), mir1(row(i),col(i)), mir2(row(i),col(i)), mir3(row(i),col(i))];
 end

% 
% PROBLEM 3A) PREPARE DATA FOR CLASSIFICATION
% Reshape image into one long vector of pixel band values.
% Convert from uint8 to double for classification.

   nx=400;
   ny=400;
   N=nx*ny;
   nz=7;
   AllPix=[reshape(red,N,1),reshape(nir,N,1),reshape(blue,N,1),reshape(green,N,1),...
       reshape(mir1,N,1),reshape(mir2,N,1),reshape(mir3,N,1)];
   AllPix=double(AllPix);
   train=double(train);
   
%
% PROBLEM 3B) CLASSIFY THE IMAGE
% Classify the image. Matlab's "classify" function requires the Statistics toolbox.
%   train and sample'Allpix?' must have same number of columns.
%   train and group must have same number of rows.
%   misfit is nx-by-ny-by-ngroups and has probability (0-1) that each is a member of that group
% This may take up to a minute.  tic and toc will time the calculation
%
%
% Perform classification
%
tic
[class,err,misfit]=classify(AllPix,train,group);
toc

%
% PROBLEM 3C) LOOK AT THE CLASSIFIED IMAGE
% Reshape the Class vector and Each group error vetor (Nx1) back into an nx x ny matrix.
%
class=reshape(class,nx,ny);
misfit=reshape(misfit,nx,ny,ngroup);
%
% Visualize the classification.
% You could do this with any colormap, or you can make your own with RGB values
% for each Group Number that make sense to you. Feel free to use the map below
% or make your own.
%   
   map=[1,0.96863,0.92157;...          % Group 1: Clouds
        0.72941,0.83137,0.95686;...    % Group 2: Sea Ice
        0,0.74902,0.74902;...          % Group 3: Floating Ice Shelf
        0.95294,0.87059,0.73333;...    % Group 4: Land Ice - I named it Disint.Region
        0.078431,0.16863,0.54902];     % Group 5: Open Ocean

figure(2),clf,colormap(map)
image(class),colorbar
title({'First Pixel Classification';'LightBlue: Clouds, LightTan: Sea Ice, Tan: Floating Ice Shelf, Teal: Disint.Region, DarkBlue: Open Ocean)'})

% The classification makes sense except that the sea ice extends into where
% the ocean is. The ocean pixels(dark blue) are mostly in a group, 
% with some smaller dark blue pixels scattered. The clouds(light blue) are
% also somewhat in groups but they are definitely more scattered due to the 
% clouds themselves being more spaced out and spread out among the image.



% PROBLEM 3) OPTIONAL: LOOK AT THE MISFIT
figure(3),clf,
   subplot(2,3,1),imagesc(misfit(:,:,1)),colorbar,title('Clouds')
   subplot(2,3,2),imagesc(misfit(:,:,2)),colorbar,title('Sea Ice')
   subplot(2,3,3),imagesc(misfit(:,:,3)),colorbar,title('Ice Shelf')
   subplot(2,3,4),imagesc(misfit(:,:,4)),colorbar,title('Land Ice')
   subplot(2,3,5),imagesc(misfit(:,:,5)),colorbar,title('Ocean')
   
  M=max(misfit,[],3);
   figure(4),clf
   imagesc(M),colorbar,title('Bad Pixels: max fit (1=perfect,0=bad)');

% Find the location of pixels that aren't fit well by any of the classes (max fit < 0.9)
% Change the classification (group number) of these pixels to a new group
%

   I=find(M<0.90);
   class2=class;
   class2(I)=ngroup+1;
   
   map2=[1,0.96863,0.92157;...          %  Group 1: Clouds
        0.72941,0.83137,0.95686;...    %  Group 2: Sea Ice
        0,0.74902,0.74902;...          % Group 3: Floating Ice Shelf
        0.95294,0.87059,0.73333;...    % Group 4: Land Ice - I named it Disint.Region
        0.078431,0.16863,0.54902;...    %  Group 5: Open Ocean
        0,0,0];                          %  Group 6: Bad Pixels
    
  figure(5),imagesc(class2),colormap(map2),colorbar, 
  title({'First training pixel classification + poor fit pixels';'LightBlue: Clouds, LightTan: Sea Ice, Tan: Floating Ice Shelf, Teal: Disint.Region, DarkBlue: Open Ocean)'});
  
% The pixels that didnt fit well with any of the training pixels are very
% little and mainly spread out across the image in single pixels and the error is usually
% from wherever two groups are on top of eachother.



% PROBLEM 4) Optional: REDO CLASSIFICATION WITH DIFFERENT TRAINING SET
% sea ice, clouds, region of dis, ice shelf, ocean

tpix2=[278,124,1;...% Region 1: Sea Ice
    302,138,1;...
    111,183,1;...
    248,317,2;...% Region 2: Clooooouds
    335,303,2;...
    80,86,2;...
    193,178,3;...% Region 3: Disintegration Region
    231,206,3;...
    208,152,3;...
    238,256,4;...% Region 4: Ice Shelf
    163,204,4;...
    222,395,4;...
    233,124,5;...% Region 5: Open Ocean
    19,204,5;...
    389,192,5];

row=tpix2(:,1);   % y-value
 col=tpix2(:,2);   % x-value
 group=tpix2(:,3); % group number
 ngroup=max(group);
 
 train=[];
 for i=1:length(group)
     train=[train; red(row(i),col(i)), nir(row(i),col(i)), blue(row(i),col(i))...
         ,green(row(i),col(i)), mir1(row(i),col(i)), mir2(row(i),col(i)), mir3(row(i),col(i))];
 end
    
nx=400;
   ny=400;
   N=nx*ny;
   nz=7;
   AllPix=[reshape(red,N,1),reshape(nir,N,1),reshape(blue,N,1),reshape(green,N,1),...
       reshape(mir1,N,1),reshape(mir2,N,1),reshape(mir3,N,1)];
   AllPix=double(AllPix);
   train=double(train);
   
tic
[class,err,misfit]=classify(AllPix,train,group);
toc

class=reshape(class,nx,ny);
misfit=reshape(misfit,nx,ny,ngroup);

figure(6),clf,colormap(map)
image(class),colorbar
title('Second Training Pixel Classification (better)')

% Using a different classification, I think I got a better result. The ocean
% is much more distinct and the clouds are less scattered and together. The ice shelf is
% not scattered at all and aligns pretty much perfectly with the orig pic.
% The only problem is that the disintergrated region of the ice shelf is
% pretty scattered and not only in one place. Overall, I think this one is
% better because I chose more diverse points for the training pixels for
% each group.
    
    
