% SIO 135 LAB 1

% Example Exercise # 2
n = 2048
x = [0:64:n];
y = sin(x);
plot(x,y)
pause

% Example Exercise # 3
A = rand(6,6);
B = rand(6,6);

C = A*B; % matrix multiplication

D = A.*B; % multiplying corresponding elements

imagesc(C)
colorbar southoutside
pause
imagesc(C)
colorbar southoutside
colormap gray
pause
imagesc(D)
colormap parula
colorbar southoutside
pause
imagesc(D)
colorbar southoutside
colormap gray
