% Tyler Barbero
% SIO 135 Lab 8 Optional, Spring 2019

%{ 
InSAR:
uses two or more synthetic aperture radar (SAR)
images to generate maps of surface deformation or digital elevation, 
using differences in the phase of the waves returning to the satellite
or aircraft.
Phase is the function of time usually expressed in angle (rad or deg)
%}
%
clear
%
% read in the binary images
%
  e1=fread(fopen('22388_2925.SLC','r','b'),[5488,800],'*short')';
  e2=fread(fopen('02715_2925.SLC','r','b'),[5488,800],'*short')';
%
%
% convert these arrays to complex numbers
%
  c1=double(complex(e1(:,1:2:5487),e1(:,2:2:5488)));              
  c2=double(complex(e2(:,1:2:5487),e2(:,2:2:5488))); 
  
  %calculate the phase factor of the real and inverse
  
  i1=fft2(c1);
  i2=fft(c2);
  a1=(i1.*i2)/abs(i1.*i2);
  imshow(ifft2(a1));
  figure(2), imshow(a1);
  
  

  
  
%{
  f1 = ones(4,16)/9;
  d1 = filter2(f1,c1);
  d2 = filter2(f1,c2);
  
  diff = (d1-d2);
  imshow(diff);

%}
