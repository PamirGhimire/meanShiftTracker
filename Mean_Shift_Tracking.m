%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MEAN SHIFT TRACKING
% ----------------------
% Authors: D. SIdibe
% Date: October 19th, 2011

% Pamir Ghimire
% Date : November 5, 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% read images
clc; clear all; close all;
imPath = './car'; imExt = 'jpg';

%%%%% LOAD THE IMAGES
%=======================
% check if directory and files exist
if isdir(imPath) == 0
    error('USER ERROR : The image directory does not exist');
end

filearray = dir([imPath filesep '*.' imExt]); % get all files in the directory
NumImages = size(filearray,1); % get the number of images
if NumImages < 0
    error('No image in the directory');
end

disp('Loading image files from the video sequence, please be patient...');
% Get image parameters
imgname = [imPath filesep filearray(1).name]; % get image name
I = imread(imgname);
VIDEO_WIDTH = size(I,2);
VIDEO_HEIGHT = size(I,1);

ImSeq = zeros(VIDEO_HEIGHT, VIDEO_WIDTH, NumImages);
for i=1:NumImages
    imgname = [imPath filesep filearray(i).name]; % get image name
    %%%%%%
    %%this code to be added to handle color images
%     col_im = imread(imgname);
%     gray_im = rgb2gray(col_im);
%     ImSeq(:,:,i) = gray_im;
    %%%%%%
    
    ImSeq(:,:,i) = imread(imgname); % load image
end
disp(' ... OK!');


%%%%% INITIALIZE THE TRACKER
%=======================

% HERE YOU HAVE TO INITIALIZE YOUR TRACKER WITH THE POSITION OF THE OBJECT IN THE FIRST FRAME

% You can use Background subtraction or a manual initialization!
% For manual initialization use the function imcrop
[patch, rect] = imcrop(ImSeq(:,:,1)./255);


% DEFINE A BOUNDING BOX AROUND THE OBTAINED REGION : this gives the initial state

% Get ROI Parameters
rect = round(rect);
ROI_Center = round([rect(1)+rect(3)/2, rect(2)+rect(4)/2]); 
ROI_Width = rect(3);
ROI_Height = rect(4);

% you can draw the bounding box and show it on the image


%% MEANSHIFT TRACKING
%=======================

%% FIRST, YOU NEED TO DEFINE THE COLOR MODEL OF THE OBJECT

% compute target object color probability distribution given the center and size of the ROI
imPatch = extract_image_patch_center_size(ImSeq(:,:,1), ROI_Center, ROI_Width, ROI_Height);
%%
% color distribution in RGB color space
Nbins = 8;
TargetModel = color_distribution(imPatch, Nbins);
%plot(dist, TargetModel);
%%
clc;
% Mean-Shift Algorithm 
prev_center = ROI_Center; % set the location to the previous one 
figure(2);
for n = 2:NumImages
    % get next frame
    I = ImSeq(:,:,n);
    
    figure(2);
    imshow(ImSeq(:,:,n), [])
    hold on
    
    while(1)
    	% STEP 1
    	% calculate the pdf of the previous position
    	[imPatch, r, c] = extract_image_patch_center_size(I, prev_center, ROI_Width, ROI_Height);
    	ColorModel = color_distribution(imPatch, Nbins);
    
    	% evaluate the Bhattacharyya coefficient
     	rho_0 = compute_bhattacharyya_coefficient(TargetModel, ColorModel);
    
        
    	% STEP 2
    	% derive the weights
    	weights = compute_weights(imPatch, TargetModel, ColorModel, Nbins);
    
    	% STEP 3
    	% compute the mean-shift vector
    	% using Epanechnikov kernel, it reduces to a weighted average
        z = compute_meanshift_vector(imPatch, prev_center, weights);
    
    	new_center = [c + z(2), r + z(1)];
        % show tracker's starting position
        figure(2), scatter(new_center(1), new_center(2), 'g.'); hold on;
        
    	% STEP 4, 5
        imPatch_z = extract_image_patch_center_size(I, new_center, ROI_Width, ROI_Height);
    	ColorModel_z = color_distribution(imPatch_z, Nbins);
        rho_z = compute_bhattacharyya_coefficient(TargetModel, ColorModel_z);
        while(rho_z < rho_0)
            new_center = (new_center + prev_center)/2;
            imPatch_z = extract_image_patch_center_size(I, new_center, ROI_Width, ROI_Height);
            ColorModel_z = color_distribution(imPatch_z, Nbins);
            rho_z = compute_bhattacharyya_coefficient(TargetModel, ColorModel_z);
            
            % show tracker's convergence
            figure(2), scatter(new_center(1), new_center(2), 'r.'); hold on;
        end
        
        % STEP 6
    	if norm(new_center-prev_center, 1) < 0.001
       		break
    	end
    	prev_center = new_center;
        
    end
	
    % Show your tracking results 
    rectangle('Position',[new_center(1)-ROI_Width/2, new_center(2)-ROI_Height/2, ROI_Width, ROI_Height], 'EdgeColor','r','LineWidth',1 )
    hold off
    pause(1e-6)
end




