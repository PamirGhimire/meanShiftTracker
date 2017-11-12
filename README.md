# meanShiftTracker
Mean-shift tracking using 1D histograms and Epanechnikov profile
Pamir Ghimire, November 12, 2017
Visual tracking 

This is an implementation of mean-shift tracking using 1D histograms 
and epanechnikov kernel. Target to be tracked has to be initialized
manually. 

Set up your project directory as follows:
	ProjectDir:
		- .m files
		- car (containing car sequence (jpg) )

To view my implementation of Mean-shift tracking,
run Mean_Shift_Tracking.m

It uses the following functions:
1. color_distribution
	
	cd = color_distribution(imagePatch, Nbins)

2. compute_bhattacharya_coefficient
	
	bdist = compute_bhattacharyya_coefficient(targetmodel, colormodel)

3. compute_meanshift_vector
	
	z = compute_meanshift_vector(imPatch, prev_center, weights)

4. compute_weights
	
	weights = compute_weights(imPatch, TargetModel, ColorModel, Nbins)

5. extract_image_patch_center_size
	
	[imPatch, r, c] = extract_image_patch_center_size(I, c, w, h)
	
	i : I = image, c = center, w = patch width, h = patch height
	
	o : r, c = origin of the patch in image coordinates
