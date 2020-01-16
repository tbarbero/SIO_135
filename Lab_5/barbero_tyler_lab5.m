% Tyler Barbero
% SIO135 Lab 5, Spring 2019
%
clear
%
% Problem 1) Image contrast enhancement
%

%
% read and display the thermal infrared band
% Band 6 = Thermal-IR band
ir = fread( fopen( 'band6c.raw', 'r'), [1500 1500], '*uint8')';
figure(1),colormap('gray');
imshow(ir)
title( 'Original Data' );

%
% linear contrast stretch (set display limits in imshow)
%
min_pixel = min(min(ir));
max_pixel = max(max(ir));
figure(2),colormap('gray'),
imshow(ir, [min_pixel max_pixel])
title( 'Linear Stretch' );

%
% histogram equallization using built-in matlab function histeq()
%
figure(3),colormap('gray')
histeq(ir)
title( 'Histogram Equalization' );

%
% look at the histogram for each
%
figure(4),colormap('gray');
subplot(2,1,1), imhist(ir), title('Original Image Histogram'), xlabel('Pixel Value'), ylabel('Number of Pixels');
subplot(2,1,2), imhist(histeq(ir)), title('Equalized Image Histogram'), xlabel('Pixel Value'), ylabel('Number of Pixels');

% In the ocean areas, I see distinct horizontal lines, more so in the
% equalized histogram.

%
% Problem 2)
%

%
% read in 3 bands
%
bl = fread( fopen( 'band1c.raw', 'r'), [1500 1500], '*uint8')';
gr = fread( fopen( 'band2c.raw', 'r'), [1500 1500], '*uint8')';
rd = fread( fopen( 'band3c.raw', 'r'), [1500 1500], '*uint8')';
% look at the RGB image with contrast enhancement
% 
% Without histrogram, image looks blue because the histogram values are so
% scrunched together rather than spread out
%
rgb = cat(3, rd, gr, bl);
figure(5), imshow(rgb), title( 'RGB Image' );

%
% enhance the contrast in each band, and look at the histogram for each
%
figure(6);
rdeq = histeq(rd);
greq = histeq(gr);
bleq = histeq(bl);
subplot(3,2,1), imhist(rd), title('Red'), xlabel('Pixel Value'), ylabel('Number of Pixels');
subplot(3,2,2), imhist(rdeq), title('Red Equalized'), xlabel('Pixel Value'), ylabel('Number of Pixels');
subplot(3,2,3), imhist(gr), title('Green'), xlabel('Pixel Value'), ylabel('Number of Pixels');
subplot(3,2,4), imhist(greq), title('Green Equalized'), xlabel('Pixel Value'), ylabel('Number of Pixels');
subplot(3,2,5), imhist(bl), title('Blue'), xlabel('Pixel Value'), ylabel('Number of Pixels');
subplot(3,2,6),imhist(bleq), title('Blue Equalized'), xlabel('Pixel Value'), ylabel('Number of Pixels');


%
% combine the equalized bands and have a look
%
figure(7);
rgbeq = cat( 3, rdeq, greq, bleq );
imshow(rgbeq), title( 'RGB Equalized' );

%fig5(normal) vs fig7(equalized)(contrast enhanced)

% Problem 3) image enhancement through filtering
%

%
% load & show the un-touched image
%
blrrq = fread( fopen( 'band1c.raw', 'r'), [1500 1500], '*uint8')';
figure(8),colormap('gray'),
imagesc( blrrq ),
title('Original');
 
%
% apply a smoothing filter
%
smoothfilt=[1/9, 1/9, 1/9; 1/9, 1/9, 1/9; 1/9, 1/9, 1/9];

bl_smooth = filter2( smoothfilt, blrrq ); % filter2 applies filter to matrix bl according to coeff in smoothfilt
figure(9),colormap('gray'),
imagesc( bl_smooth ),
title('Smoothed');

%
% apply a sharpening filter
%
sharpfilt=[-1/9, -1/9, -1/9; -1/9, 51/9, -1/9; -1/9, -1/9, -1/9];
bl_sharp = filter2(sharpfilt, blrrq);
figure(10),colormap('gray')
imagesc(bl_sharp),
title('Sharpened');
%
% illuminate from the southwest (sobel filter)
% If the sun is in the southwest, the shadow would be on the inside of the
% coastline which it is and this makes sense.
sobelfilt=[0,1,50;-1,0,1;-50,-1,0];
bl_sobel = filter2(sobelfilt, blrrq);
figure(11),colormap('gray')
imagesc(bl_sobel),
title('SW Illumination')

%
% Problem 4) compute the vegetation index
% NDVI of value 1 means highest density vegetation while 0 is practically none.
% read in apropriate bands and convert them to doubles.
% 
red = double(fread( fopen( 'band3c.raw', 'r'), [1500 1500], '*uint8')');
ir = double(fread( fopen( 'band4c.raw', 'r'), [1500 1500], '*uint8')');

%
% compute the vegetation index band transformation and display with imagesc
% 
figure(12),
NDVI = (ir-red)/(ir+red);
NDVI;
imagesc(NDVI, [0 255])

%{
%Bonus Problem 5 principal component analysis
%
%
clf
clear
%
%  read the 7 bands
%
b1 = fread( fopen( 'band1c.raw', 'r'), [1500 1500], '*uint8')';
b2 = fread( fopen( 'band2c.raw', 'r'), [1500 1500], '*uint8')';
b3 = fread( fopen( 'band3c.raw', 'r'), [1500 1500], '*uint8')';
b4 = fread( fopen( 'band4c.raw', 'r'), [1500 1500], '*uint8')';
b5 = fread( fopen( 'band5c.raw', 'r'), [1500 1500], '*uint8')';
b6 = fread( fopen( 'band6c.raw', 'r'), [1500 1500], '*uint8')';
b7 = fread( fopen( 'band7c.raw', 'r'), [1500 1500], '*uint8')';
%
%  image the 7 bands
%
figure(1),colormap('gray'),imagesc(b1),colorbar,title(' band 1')
figure(2),colormap('gray'),imagesc(b2),colorbar,title(' band 2')
figure(3),colormap('gray'),imagesc(b3),colorbar,title(' band 3')
figure(4),colormap('gray'),imagesc(b4),colorbar,title(' band 4')
figure(5),colormap('gray'),imagesc(b5),colorbar,title(' band 5')
figure(6),colormap('gray'),imagesc(b6),colorbar,title(' band 6')
figure(7),colormap('gray'),imagesc(b7),colorbar,title(' band 7')
pause
%
% load them all into a 3-D matrix
%
a=zeros(1500,1500,7);
a(:,:,1)=double(b1)-mean(mean(b1));
a(:,:,2)=double(b2)-mean(mean(b2));
a(:,:,3)=double(b3)-mean(mean(b3));
a(:,:,4)=double(b4)-mean(mean(b4));
a(:,:,5)=double(b5)-mean(mean(b5));
a(:,:,6)=double(b6)-mean(mean(b6));
a(:,:,7)=double(b7)-mean(mean(b7));

%}