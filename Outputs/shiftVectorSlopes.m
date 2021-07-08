load('C:\Users\chris\Documents\MATLAB\WarpDrive\ML\AdaptiveSearch\New Runs\Cylinders\RunData-6-4z-30r-2v.mat')
Cyl_4z = RunData.shiftMatricies{end};

load('C:\Users\chris\Documents\MATLAB\WarpDrive\ML\AdaptiveSearch\New Runs\Cylinders\RunData-6-9z-20r-2v.mat')
Cyl_9z = RunData.shiftMatricies{end};

load('C:\Users\chris\Documents\MATLAB\WarpDrive\ML\AdaptiveSearch\New Runs\Cylinders\RunData-6-16z-15r-2v.mat')
Cyl_16z = RunData.shiftMatricies{end};

load('C:\Users\chris\Documents\MATLAB\WarpDrive\ML\AdaptiveSearch\New Runs\Cylinders\RunData-6-25z-12r-2v.mat')
Cyl_25z = RunData.shiftMatricies{end};

load('C:\Users\chris\Documents\MATLAB\WarpDrive\ML\AdaptiveSearch\New Runs\Cylinders\RunData-6-36z-10r-2v.mat')
Cyl_36z = RunData.shiftMatricies{end};

load('C:\Users\chris\Documents\MATLAB\WarpDrive\ML\AdaptiveSearch\New Runs\Spheres\RunData-6-14z-14r-2v.mat')
Sph_AM_end = RunData.shiftMatricies{end};
Sph_AM_start = RunData.shiftMatricies{1};


%%
x = 1:26;
a = 27;
b = 0.06;
f = b*(a*cosh(x/a)-sqrt(a^2-x.^2));


hold on
% plot(Cyl_4z(30-1:30+25,35),'r')
% plot(Cyl_9z(20-1:20+25,35),'g')
% plot(Cyl_16z(15-1:15+25,35),'b')
% plot(Cyl_25z(12-1:12+25,35),'Color',[1 0 1])
% plot(Cyl_36z(10-1:10+25,35),'Color',[0 1 1])

%plot(Sph_AM_start(14-1:14+25,35),'k')
plot(Sph_AM_end(14-1:14+25,35),'b')
plot(fliplr(x(2:26)),f(2:26),'k')


xlabel('Radial Extent from Edge')
ylabel('\beta')
legend('Numerical Form (Optimized Spherical)','Analytic Form')
% title('Shift Vector Value as a Function of Distance')
title('Shift Vector Functional Form Comparison')
