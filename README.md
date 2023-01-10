# IPC and Autoware.Universe Setup
Installation scripts for configuring an IPC computer with Autoware.Universe

# Environment 
|Ubuntu|Ros2|Autoware|Nvidia Driver|CUDA Version|
|:---:|:---:|:---:|:---:|:---:|
|20.04|galactic|universe/(galactic branch)|470.63.01|11.4+|

# Minimum Hardware Requirements 
|CPU|RAM|GPU|
|:---:|:---:|:---:|
|8 cores|16 GB|NVIDIA 4GB RAM|

## GPU is not required to run basic functionality, it is mandatory to enable the following neural network related functions:
* LiDAR based object detection
* Camera based object detection
* Traffic light detection and classification

