% demo run script for analysing illuminated plant root %

% the master function of all is called analyse plant illumination
% it will analyse the image with the help of multiple sub functions that
% will do all brigthen, denoising, sharpen, segmentation and object detection
% in order to return statistical output at the end.

% Usage
% navigate matlab to directory containing this folder
% type 'main' and hit enter
% ctrl + c to terminate the process or enter to proceed

close all
clear
clc

addpath('./Images'); % import input image
addpath(genpath('./Plant_Analyser')); % import Functions

% change this to 0 to suppress inner progress output
verbose = 1;

image1 = imread("StackNinja1.bmp");
analyse_plant_illumination(image1, verbose);
disp("Hit Enter to proceed to next analysis");
pause;
close all
clc

image2 = imread("StackNinja2.bmp");
analyse_plant_illumination(image2, verbose);
disp("Hit Enter to proceed to next analysis");
pause;
close all
clc

image3 = imread("StackNinja3.bmp");
analyse_plant_illumination(image3, verbose);


