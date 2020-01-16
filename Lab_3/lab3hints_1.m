% load the topography image
fid = fopen('lajolla_swab','r');
topo = fread(fid,[3240,1440],'int16')';
