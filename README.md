# Manhattan World Max Stabbing (MWMS)
This repository provides supplementary materials and a MATLAB implementation of under-reviewed IEEE RA-L paper: "Quasi-globally Optimal and Efficient Visual Compass in Urban 3D Structured Environments" for the purpose of research and study only.
Note that this repository only includes simplified proposed 3-DoF rotation estimation example codes to understand how the MWMS works in structured environments.

![MWMS](https://github.com/PyojinKim/MWMS/blob/main/overview.png)


# 1. Goal
Our goal is to estimate the drift-free 3-DoF rotational motion of the camera with respect to the indoor/outdoor Manhattan structured environments.
The MWMS first detects and tracks the vertical dominant direction from an RGB-D camera or an IMU to compute 2-DoF of the MF rotation, and then searches for the optimal third DoF by the proposed Mine-and-Stab (MnS).
Once we find an initial rotation estimate of the camera, we refine the absolute camera orientation by minimizing the average orthogonal distance from the endpoints of the lines to the MW axes.
Our method is not sensitive to noise and can achieve quasi-global optimality.

![MWMS](https://github.com/PyojinKim/MWMS/blob/main/result.png)


# 2. Prerequisites
This package is tested on the MATLAB R2020a on Windows 10 64-bit.
Some of the functions such as estimateSurfaceNormalGradient_mex.mexw64 are compiled as MEX file to speed up the computation.
You can use estimateSurfaceNormalGradient.m instead if you cannot compile MEX file in your OS.


# 3. Usage
* Download the ICL-NUIM dataset from https://www.doc.ic.ac.uk/~ahanda/VaFRIC/iclnuim.html, 'of kt0' is recommended.

* Or, Use the ICL-NUIMdataset/of_kt0/ included in this package.

* Define 'datasetPath' correctly in your directory at setupParams_ICL_NUIM.m file.

* Run MWMS_core/main_script_ICL_NUIM.m, which will give you the 3-DoF camera orientation tracking result. Enjoy! :)

