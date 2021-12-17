%% Cylinder Data

load('C:\Users\j90xb\Desktop\WarpDrive_Project\ML\AdaptiveSearch\New Runs\Cylinders\RunData-6-4z-30r-2v.mat')
Metric = makeMetricPW(RunData.shiftMatricies{end}, 3);
StressEnergyTensor = met2den(Metric);
E_cyl_4z = sum(StressEnergyTensor{1,1},'all');

load('C:\Users\j90xb\Desktop\WarpDrive_Project\ML\AdaptiveSearch\New Runs\Cylinders\RunData-6-9z-20r-2v.mat')
Metric = makeMetricPW(RunData.shiftMatricies{end}, 3);
StressEnergyTensor = met2den(Metric);
E_cyl_9z = sum(StressEnergyTensor{1,1},'all');

load('C:\Users\j90xb\Desktop\WarpDrive_Project\ML\AdaptiveSearch\New Runs\Cylinders\RunData-6-16z-15r-2v.mat')
Metric = makeMetricPW(RunData.shiftMatricies{end}, 3);
StressEnergyTensor = met2den(Metric);
E_cyl_16z = sum(StressEnergyTensor{1,1},'all');

load('C:\Users\j90xb\Desktop\WarpDrive_Project\ML\AdaptiveSearch\New Runs\Cylinders\RunData-6-25z-12r-2v.mat')
Metric = makeMetricPW(RunData.shiftMatricies{end}, 3);
StressEnergyTensor = met2den(Metric);
E_cyl_25z = sum(StressEnergyTensor{1,1},'all');

load('C:\Users\j90xb\Desktop\WarpDrive_Project\ML\AdaptiveSearch\New Runs\Cylinders\RunData-6-36z-10r-2v.mat')
Metric = makeMetricPW(RunData.shiftMatricies{end}, 3);
StressEnergyTensor = met2den(Metric);
E_cyl_36z = sum(StressEnergyTensor{1,1},'all');

%% Sphere Data
load('C:\Users\j90xb\Desktop\WarpDrive_Project\ML\AdaptiveSearch\New Runs\Spheres\RunData-6-14z-14r-2v.mat')
Metric = makeMetricPW(RunData.shiftMatricies{end}, 3);
StressEnergyTensor = met2den(Metric);
E_AM_opt = sum(StressEnergyTensor{1,1},'all');

Metric = makeMetricPW(RunData.shiftMatricies{1}, 3);
StressEnergyTensor = met2den(Metric);
E_AM_start = sum(StressEnergyTensor{1,1},'all');

%% Process Data
load('Outputs\WarpDriveStyle.mat')

h = figure()
hold on
plot([4 9 16 25 36],[E_cyl_4z E_cyl_9z E_cyl_16z E_cyl_25z E_cyl_36z])
yline(E_AM_start,'r-','Alcubierre')
yline(E_AM_opt,'g--','Optimized Spherical')
a = annotation('textarrow',[0.4 0.3],[0.8 0.7],'String','Cylinders')
a.Color = [0, 0.4470, 0.7410];
set(gca,'Yscale','log')
xlabel('Z size')
ylabel('Total Energy [J]')
  s.Format = 'png';
    hgexport(h,'temp_dummy',s,'applystyle', true);
