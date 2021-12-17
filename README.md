# WarpDrive
**Code to numerically optimize warp drive geometries**

## Basic use
- Clone repository to desired folder using ``` git clone https://github.com/pbbp0904/WarpDrive.git ```
- Add the folders and subfolders of Metrics, Scripts, and sliceomatic to your MATLAB path (either temporarily or permanently)
- Run optimization scripts in the Optimization folder or create new scripts inside the Optimization folder
- Use sliceomatic and scripts in the Outputs folder to visualize and benchmark the saved states of your optimization runs

## More info on Folders
- The core computation of the Stress-Energy-Momentum tensor from the metric tensor occurs in the Scripts folder.
- The Metrics folder contains scripts and functions that generate predefined warp metric. These can be used for analysis or as a starting point for an optimization run.
- The Optimization folder contains scripts that take an initial warp metric and perturb it with the goal of achieving a lower total energy
- The sliceomatic tool is handy to quickly visualize metrics and energy densities in 3D space. Call it by passing it a x by y by z array of values: sliceomatic(my3DArray)

## Contact
Christopher Helmerich: cdh0028@uah.edu  
Jared Fuchs: jef0011@uah.edu

## Publications
- AIAA 2021: https://arc.aiaa.org/doi/10.2514/6.2021-3596
- AIAA 2021: https://youtu.be/6IrGPvwRam8
