% Tyler Barbero
% SIO135 Lab 3, Spring 2019
%
clear, figure(1)
%
% Problem 1) Blackbody Radiation
% constants
%
   c = 2.99e8;	% speed of light [m/s]
   h = 6.63e-34;	% Planck's constant [J s]
   k = 1.38e-23;	% Boltzmann's constant [J/K]
   B = 2.898e-3;	% Wein's Law constant [K m]

   T = 300;		% Temperature [K]
   lam = logspace(-8,1,100);	% wavelength [m] 
%
% Plank's Law
%
L=(2*pi.*h.*c.^2)./(lam.^5)./(exp(h.*c./(lam.*k.*T))-1);
loglog(lam,L,'DisplayName','Earth 300k')
xlim([10^-10 10^2])
xlabel('Lamba (Wavelength (m))')
ylabel('Spectral Radiance (W/m^2)')
title('Spectral Radiance vs Wavelength at serveral Temperatures'), hold on;

T = 1000;
L=(2*pi.*h.*c.^2)./(lam.^5)./(exp(h.*c./(lam.*k.*T))-1);
loglog(lam,L)
T = 6000;
L=(2*pi.*h.*c.^2)./(lam.^5)./(exp(h.*c./(lam.*k.*T))-1);
loglog(lam,L)
legend('Earth 300k','1000k','Sun 6000k'), hold off
%
% Wiens Law: Lambda = B/T;
T1 = 300;
L1 = B/T1;
T2 = 1000;
L2 = B/T2;
T3 = 6000;
L3 = B/T3;
L1
L2
L3

% at T = 300 lam = 9.66E-6 L = 1.091E7
% at T = 1000 lam = 2.898E-6, L = 1.138E9
% at T = 6000 lam = 4.83E-7, L = 4.44E13
text(10^-10,10^25,'LamMax(Sun) = 4.83E-7m')
text(10^-9,10^40, 'LamMax(1000k) = 2.898E-6m')
text(10^-6.5,10^25,'LamMax(Earth) = 9.66E-6m')

pause

%
% Problem 2) La Jolla Topography
%
% load the topography image into matlab
%
   fid=fopen('lajolla_swab','r');
   topo=fread(fid,[3240,1440],'int16')';
%
% image the topography
%
figure(2)
imagesc([-1000,1000],[-1000,1000],topo)
title('La Jolla Topography')
pause
%
% illuminate the topography
%
figure(3)
A = diff(topo);
imagesc([-1000,1000],[-1000,1000],A);
title('Illumintated Topography')
pause

%
% Problem 3) RGB image
%
% read in a jpg image
%
   z = imread('Paraglider.jpg');
   size(z)
%
% separate out the red, blue, and green components
%
   r=z(:,:,1);
   g=z(:,:,2);
   b=z(:,:,3);
%
% look at the components
%
   figure(4),clf
   subplot(2,2,1),imshow(z),title('composite')
   subplot(2,2,2),imshow(r),title('red')
   subplot(2,2,3),imshow(g),title('green')
   subplot(2,2,4),imshow(b),title('blue'), pause
%
% recombine components
%
   figure(5)
   subplot(2,2,1),imshow(cat(3,r,g,b)),title('r,g,b')
% After recombining int a rbg image, I get the same picture as before.
   subplot(2,2,2),imshow(cat(3,g,r,b)),title('g,r,b')
% I switched the red and green channels, the red objects became red, the
% green objects (grass) sort of became reddish-tint. I think the grass didnt
% become fully red because there was no red to begin with.

% Another combination
subplot(2,2,3),imshow(cat(3,b,g,r)),title('b,g,r')
%
% write an image to a jpg file
%
   outimage=cat(3,b,g,r);
   imwrite(outimage,'ParaBGR.jpg');

