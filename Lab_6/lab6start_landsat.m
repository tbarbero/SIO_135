%
% SIO135/236 Lab 6, Spring 2013
%
%clear;
%
% PROBLEM 1) READ IN THE IMAGE AND LOOK AT THE BANDS
% read in and look at all 7 bands with linear stretch (imagesc)
%

   bl  = fread( fopen( 'band1c.raw', 'r'), [1500 1500], '*uint8')';
   gr  = fread( fopen( 'band2c.raw', 'r'), [1500 1500], '*uint8')';
   rd  = fread( fopen( 'band3c.raw', 'r'), [1500 1500], '*uint8')';
   nir = fread( fopen( 'band4c.raw', 'r'), [1500 1500], '*uint8')';
   mir1= fread( fopen( 'band5c.raw', 'r'), [1500 1500], '*uint8')';
   ir  = fread( fopen( 'band6c.raw', 'r'), [1500 1500], '*uint8')';
   mir2= fread( fopen( 'band7c.raw', 'r'), [1500 1500], '*uint8')';

   figure(1),clf,colormap(gray)
   subplot(2,4,1),imagesc(bl),colorbar,title('blue-green')
   subplot(2,4,2),imagesc(gr),colorbar,title('green')
   subplot(2,4,3),imagesc(rd),colorbar,title('red')
   subplot(2,4,5),imagesc(nir),colorbar,title('near-IR')
   subplot(2,4,6),imagesc(mir1),colorbar,title('mid-IR')
   subplot(2,4,7),imagesc(ir),colorbar,title('thermal-IR')
   subplot(2,4,8),imagesc(mir2),colorbar,title('mid-IR')
%
% look at the rgb image
%
   figure(2),clf
   imshow(cat(3,histeq(rd),histeq(gr),histeq(bl)))
%
% See lab6demo.m for how to do the rest of this lab.
%
