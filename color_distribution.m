function cd = color_distribution(imagePatch, m)
% 'm' is the number of bins
% cd is the color-distribution of the imagePatch

% initialize histogram bin-centroids using 'm'
histLimits = linspace(0, 255, m+1);
centroids = zeros(1, m);
for i = 1:m
    centroids(i) = round( 0.5 * (histLimits(i) + histLimits(i+1)) );
end

% cd is color distribution, which is output of the function
cd = zeros(size(centroids));
patch_center = round(0.5* [size(imagePatch, 1), size(imagePatch, 2)]);

% maximum distance of a pixel within patch to the center pixel
x_normalizer = sum( abs(patch_center - [1, 1]) .^2 ) ;

% for each pixel in the patch
for nrow = 1:size(imagePatch, 1)
    for ncol = 1:size(imagePatch, 2)
       
        % find out which bin of patchHist it contributes to
        pixelIntensity = imagePatch(nrow, ncol);
        IntensityDistsFromBinCentroids = abs(centroids - pixelIntensity);
        [mindist, histBin] = min(IntensityDistsFromBinCentroids);
        
        % find out its normalized distance from the center
        x = sum( abs(patch_center - [nrow, ncol]) .^ 2 );
        x = x/x_normalizer;
                
        % update bin location by weighting it with function of the distance
        % using Epanechnikov profile
        if (x < 1)
            kx = (1/(2 * pi)) * (1 - x);
        else
            kx = 0;
        end    
        
        cd(histBin) = cd(histBin) + kx;
        
    end
end

cd = (1 / sum(cd)) * cd;

end
