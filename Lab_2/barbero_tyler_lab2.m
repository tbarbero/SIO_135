% SIO 135 Lab 2

% Exercise 1
figure(1)
nx=2048;
kc=64/nx;
x=0:nx-1;


%
% now make the function and plot it.
%
y=sin(2*pi*kc*x);
plot(x,y)
xlabel('x')
ylabel('sin(x)')
title('Sin(x) 64 Cycles')
pause

% Exercise 2
% Take the fourier transform of the function from 1...
% notes: FFT of a function (time > freq)
%      : IFFT of function (time to freq)

% generate the wavenumbers
figure(2)

subplot(5,1,1),plot(x,y)
xlabel('x')
ylabel('sin(x)')
title('Sine Function')

k = -nx/2:nx/2-1;

cy=fftshift(fft(y));

subplot(5,1,2),plot(k,real(cy)) % Creates a mxn with position p [subplot(m,n,p)]
xlabel('Wavenumber')
ylabel('F.T.(y) real')
title('K vs FFT(real)')

subplot(5,1,3),plot(k,imag(cy))
xlabel('Wavenumber')
ylabel('F.T.(y) imaginary')
title('K vs FFT(imag)')

% Take the inverse fourier transform of the function 

by = ifft(fftshift(cy));

% Plot the Inverse fourier transform

subplot(5,1,4),plot(x,real(by))
xlabel('Time')
ylabel('Inverse F.T.(y)')
title('Time v IFFT(real)')

subplot(5,1,5),plot(x,real(by)-y)
xlabel('Time')
ylabel('Function Difference')
title('Time v difference IFFT(real) and sine function')

pause

% Do you get what you started with? What happens if you
% use an even function instead of an odd function (or vice versa)?

% After taking the inverse fourier transform I get the same thing as I
% started with.
% Using an even function the plot is just shifted over pi/2. For the real
% transform, it has two lines upward instead of downward. The imaginary for
% even cosine function is scaled down to the ^-14.

% Exercise 3
% Create a 2-D array of numbers 400 x 300 using meshgrid...

%  setup the mesh

figure(3)
colormap('gray')
nx=400;
x=-nx/2:nx/2-1;
ny=300;
y=-ny/2:ny/2-1;
[X,Y]=meshgrid(x,y);
%
%  set the horizontal wavenumber
%
kc=20/nx;
%
%  a sine function of x
%
f=sin(1/64*X*kc);
g=sin(2*pi*X*kc);  
C = f.*g;
imagesc(C)
colorbar southoutside
xlabel('x = 400')
ylabel('y = 300')
title('Product of 2 Sine Waves')

pause

C(100:110, 50:60) = 0.06;
imagesc(C)
colorbar southoutside
xlabel('x = 400')
ylabel('y = 300')
title('Product of 2 Sine Waves') 
% A visible gray box appears in the values of 100:110, 50:60 on the new
% plot.

pause

% Exercise 4

% Create a 1024x1024 array of zeros

Q = zeros(1024); % square maxtrix

% Insert a rectangular patch of ones into array of zeros
Q(2:40, 3:30) = 1; % a 38x77 patch of ones is the aperture
QQ = fft(Q);
figure(4)
plot(QQ)

pause

% Changing the y changes the color of the plot.
% Changing the x changes the shape of the aperture
% Intervals of X closer to 1 on the x gives a circle?


% Exercise 5

% Create your own aperture and examine its fourier transform

figure(5)

F = zeros(1024); % square maxtrix

F(2:401:562, 3:90:1024) = 1; % a 38x77 patch of ones is the aperture
FF = fft(F);
plot(FF)

pause





