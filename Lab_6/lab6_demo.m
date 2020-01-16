%
% SIO135/236 Lab 6 Demo, Spring 2013
%
% This mfile demonstrates image classification of a simple 3-band (RGB) image.
% For Lab 6, you will classify a 7-band Landsat image.  All steps after the 
% initial reading in of data are done in the same way.
%
clear;
%
% PROBLEM 1) READ IN THE IMAGE AND LOOK AT THE BANDS
% Read in the 3-band image.  Look at the composite RGB and at each band
%
   z=imread('demo.jpg');
   r=z(:,:,1);
   g=z(:,:,2);
   b=z(:,:,3);

   figure(1),clf
   subplot(2,2,1),imshow(cat(3,r,g,b)),title('composite')
   subplot(2,2,2),imshow(r),colorbar('horiz'),title('red')
   subplot(2,2,3),imshow(g),colorbar('horiz'),title('green')
   subplot(2,2,4),imshow(b),colorbar('horiz'),title('blue')
%
% PROBLEM 2) CREATE A TRAINING SET
% Identify the location (row,column) of "training pixels" and assign them a "group number":
% You will need to identify at least 2 training pixels per group
% 
   tpix=[311,134,1;... % Group 1: Sea Ice y then x, group number
          209,98,1;... 
         1351,1409,2;... % Group 2: 
         673 ,394 ,2;...
         285 ,1762,3;... % Group 3: Red Tub
	 177 ,1542,3;...
	 538 ,1754,4;... % Group 4: Blue Tub
	 432 ,1811,4;...
	 1417,2010,5;... % Group 5: White Tub
	 163 ,1733,5;...
	 652 ,677 ,6;... % Group 6: Baby
	 864 ,1032,6;...
	 836 ,1882,7;... % Group 7: Dark Doormat
	 1063,1917,7]; 

   row=tpix(:,1);   % y-value
   col=tpix(:,2);   % x-value
   group=tpix(:,3); % group number
   ngroup=max(group);
%
% From these pixels, make a training set consisting of each training pixel's band values
% "train" should have the same number of rows as the number of training pixels, and the
% same number of columns as number of bands (in this case 3, in Lansat case 7).  
%   
   train=[];
   for i=1:length(group)
     train=[train; r(row(i),col(i)), g(row(i),col(i)), b(row(i),col(i))];
   end
%
% PROBLEM 3A) PREPARE DATA FOR CLASSIFICATION
% Reshape image into one long vector of pixel band values.
% Convert from uint8 to double for classification.
%
   nx=1536;
   ny=2048;
   N=nx*ny;
   nz=3;
   AllPix=[reshape(r,N,1),reshape(g,N,1),reshape(b,N,1)];
   
   AllPix=double(AllPix);
   train=double(train);
%
% PROBLEM 3B) CLASSIFY THE IMAGE
% Classify the image. Matlab's "classify" function requires the Statistics toolbox.
%   train and sample must have same number of columns.
%   train and group must have same number of rows.
%   misfit is nx-by-ny-by-ngroups and has probability (0-1) that each is a member of that group
% This may take up to a minute.  tic and toc will time the calculation
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
% for each Group Number that make sense to you.
%   
   map=[255,212,116;...   % Group 1: Yellow Bat
        155,140,135;...   % Group 2: Grey Concrete
	183,032,047;...   % Group 3: Red Tub
	048,065,095;...   % Group 4: Blue Tub
        255,255,255;...   % Group 5: White Tub
	209,156,138;...   % Group 6: Baby
	051,055,056]/255; % Group 7: Dark Doormat
   
   figure(2),clf,colormap(map)
   image(class),colorbar
   title('1=Yellow Bat, 2=Grey Concrete, 3=Red Tub, 4=Blue Tub, 5=White Tub, 6=Baby, 7=Dark Doormat')
%
% PROBLEM 4) OPTIONAL: LOOK AT THE MISFIT
% Now identify pixels that weren't well fit by any of the Groups we identified.
% Look at the posterior fits for each group. 1=Good Fit, 0=Really Bad Fit
%
   figure(3),clf,
   subplot(2,4,1),imagesc(misfit(:,:,1)),colorbar,title('Yellow Bat')
   subplot(2,4,2),imagesc(misfit(:,:,2)),colorbar,title('Grey Concrete')
   subplot(2,4,3),imagesc(misfit(:,:,3)),colorbar,title('Red Tub')
   subplot(2,4,4),imagesc(misfit(:,:,4)),colorbar,title('Blue Tub')
   subplot(2,4,5),imagesc(misfit(:,:,5)),colorbar,title('White Tub')
   subplot(2,4,6),imagesc(misfit(:,:,6)),colorbar,title('Baby')
   subplot(2,4,7),imagesc(misfit(:,:,7)),colorbar,title('Dark Doormat')
%
% Look at the maximum fit achieved for each pixel
%
   M=max(misfit,[],3);
   figure(4),clf
   imagesc(M),colorbar,title('maximum fit (1=perfect,0=not at all)')
%
% Find the location of pixels that aren't fit well by any of the classes (max fit < 0.9)
% Change the classification (group number) of these pixels to a new group
%
   I=find(M<0.90);
   class2=class;
   class2(I)=ngroup+1;
%
% Visualize the classification again, this time taking into account pixels that are poorly fit
%   
   map=[255,212,116;...   % Group 1: Yellow Bat
        155,140,135;...   % Group 2: Grey Concrete
	183,032,047;...   % Group 3: Red Tub
	048,065,095;...   % Group 4: Blue Tub
        255,255,255;...   % Group 5: White Tub
	209,156,138;...   % Group 6: Baby
	081,085,086;      % Group 7: Dark Doormat
	000,000,000]/255; % Group 8: Poorly Fit Pixels
   
   figure(5),clf,colormap(map)
   image(class2),colorbar
   title('1=Yellow Bat, 2=Grey Concrete, 3=Red Tub, 4=Blue Tub, 5=White Tub, 6=Baby, 7=Dark Doormat, 8=Bad Fit')

% PROBLEM 5) OPTIONAL: REDO THE CLASSIFICATION WITH A BETTER TRAINING SET
