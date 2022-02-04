# Manhattan World Max Stabbing (MWMS)
This repository provides supplementary materials and a MATLAB implementation of IEEE Robotics and Automation Letters (RA-L) with ICRA 2022 paper: "Quasi-globally Optimal and Real-time Visual Compass in Manhattan Structured Environments" for the purpose of research and study only.
Note that this repository only includes simplified proposed 3-DoF rotation estimation example codes to understand how MWMS works in Manhattan structured environments.

![MWMS](https://github.com/PyojinKim/MWMS/blob/main/overview.png)


# 1. Goal
Our goal is to estimate the drift-free 3-DoF rotational motion of the camera with respect to the indoor/outdoor Manhattan structured environments called a Manhattan frame (MF).
MWMS first detects and tracks the vertical dominant direction (VDD) from an RGB-D camera or an IMU to compute 2-DoF of the MF rotation, and then searches for the optimal third DoF by the proposed Mine-and-Stab (MnS).
Once we find an initial rotation estimate of the camera, we refine the absolute camera orientation by minimizing the average orthogonal distance from the endpoints of the lines to the MW axes.
Our method is insensitive to noise and can achieve quasi-global optimality in terms of maximizing the number of inlier lines in real-time.

![MWMS](https://github.com/PyojinKim/MWMS/blob/main/result.png)

It is noteworthy that without loss of generality, the dominant plane in any direction can be treated as a vertical dominant direction (VDD) in an indoor structured environment.


# 2. Prerequisites
We have tested this package on the MATLAB R2020a on Windows 10 64-bit.
Some of the functions such as estimateSurfaceNormalGradient_mex.mexw64 are compiled as MEX files to speed up the surface normal computation.
You can use estimateSurfaceNormalGradient.m instead if you cannot compile the MEX file in your OS.


# 3. Usage
* Download the ICL-NUIM dataset from https://www.doc.ic.ac.uk/~ahanda/VaFRIC/iclnuim.html, 'of kt0' is recommended.

* Or, Use the ICL-NUIMdataset/of_kt0/ included in this package.

* Define 'datasetPath' correctly in your directory at setupParams_ICL_NUIM.m file.

* Run MWMS_core/main_script_ICL_NUIM.m, which will give you the 3-DoF camera orientation tracking results. Enjoy! :)


# 4. License
The package is licensed under the MIT License, see http://opensource.org/licenses/MIT.

if you use MWMS in an academic work, please cite:

    @inproceedings{kim2022quasi,
      author = {Kim, Pyojin and Li, Haoang and Joo, Kyungdon},
      title = {Quasi-globally Optimal and Real-time Visual Compass in Manhattan Structured Environments},
      year = {2022},
      booktitle = {IEEE Robotics and Automation Letters (RA-L)},
     }

