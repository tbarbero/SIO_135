% Tyler Barbero
% SIO 135 Lab 7 Spring 2019
%
% Part 1: model an altimeter return waveform
%

%
% load and plot the waveform data
%
   load waveforms.dat
   t=waveforms(:,1); % time nanoseconds
   amp=waveforms(:,2); % recorded power watts
%
% plot the waveform data
%
figure(1),
scatter(t,amp,1)
xlabel('Time (ns)'),ylabel('Power (W)'),title('20 Waveform Data');
%
% Generate a model waveform.
% set the nominal model parameters. (this is an eyeball fit.)
% Half power point (t0) - the point in time where power is half 
% Sigma (sig) - rise time parameter - time it takes for signal to move from
% designated low to high - provides estimate of SWH
% A (amp) - provides an estimate of surface roughness at the 20-30 mm
% length scale. 

sig = 4;
t0 = 96;
B = (1+erf((t-t0)/(sqrt(2)*sig)));
A = mean(amp)/mean(B);
hold on;
M = A*(1+erf((t-t0)/(sqrt(2)*sig))); % M = power

%
% plot the fit to see how good it is
%
scatter(t,M,1)

% The amplitude is given by r = c*t0/2
c = 3E8;
t0_f = 95E-9 + 5.3E-3;
r = c*t0_f/2; % r = altitude of satellite
% r = 795.01km

% Standard deviation wave height
sig1 = 4E-9;
r1 = c*sig1/2;
% r1 = 0.6

% Part 2: Recessional Terraces at Durmid Hill from altimetry data
%

% In the altimetry data, I can see the recessional terraces around the Durmid Hill
% but in Google Earth imagery, you can't see it.

%
% load and plot the topography data
%
   fid = fopen('durmid.dat','r','l');
   z=fread(fid,[4424,4001],'real*4');
   nx=4424;
   ny=4001;
%
% plot the topography
%
figure(2), imagesc(z), title('Imagesc of topography data');
%
% look at a histogram of the topography data
% we need to reshape the data to a single column first
%
N = nx*ny;
z=reshape(z,N,1);
figure(3), histogram(z,1200), title('Histogram of reshaped topography data');
%
% Look at the histogram and identify peaks.  These are areas of
% "extra surface area" that correspond to the flat terraces around the hill
%
%{
The peaks are regularly spaced if you zoom into the data.

The elevation of these peaks corresponds to the elevation of the
recessional terraces. We know that figure(3) displays the frequency of data
between different elevations.

The elevation of several peaks:
%note: the bin edges is the range of elevations
1.712e4 - 53.3
1.267e4 - 51.28
1.223e4 - 50.25
1.312e4 - 48.52
1.28e4 - 47.25
1.334e4 - 46.38
1.416e4 - 45.59
1.198e4 - 45.12
1.132e4 - 44.64
1.144e4 - 44.09
1.207e4 - 43.46
1.155e4 - 42.67
%}
%
% find the median difference between the peaks. This is the annual recession rate

X = [53.3 51.28 50.25 48.52 47.25 46.38 45.59 45.12 44.64 44.09 ...
        43.46 42.67]; % each peak value
Y = mean((diff(X))); 

% Y = 0.9664 (m?) annual recession rate


