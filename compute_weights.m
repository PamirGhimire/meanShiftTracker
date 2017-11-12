function weights = compute_weights(imPatch, TargetModel, ColorModel, Nbins)

% Initialize histogram bin-centroids according to Nbins
histLimits = linspace(0, 255, Nbins+1);
centroids = zeros(1, Nbins);
for ncentroid = 1:Nbins
    centroids(ncentroid) = 0.5*(histLimits(ncentroid) + histLimits(ncentroid + 1));
end

weights = zeros(size(imPatch));

% for each location in the target patch
for nrow = 1:size(imPatch, 1)
    for ncol = 1:size(imPatch, 2)
        % find the bin index to which the pixel in TargetModel at (nrow,
        % ncol) belongs
        patchIntensity = imPatch(nrow, ncol);
        dists = abs(centroids - patchIntensity);
        [mindist, histBin] = min(dists);
        
        % find ratio at this bin index : sqrt(colormodel/targetmodel)
        if (ColorModel(histBin) > 0)
            weights(nrow, ncol) = sqrt( TargetModel(histBin) / ColorModel(histBin) );
        end
    end
end

end
