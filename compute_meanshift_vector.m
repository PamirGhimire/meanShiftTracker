function z = compute_meanshift_vector(imPatch, prev_center, weights)

nrows = size(imPatch, 1);
ncols = size(imPatch, 2);

z = [0, 0];
for nrow = 1:nrows
    for ncol = 1:ncols
        z = z + weights(nrow, ncol) * [nrow, ncol];
    end
end

z = z / sum(weights(:));

end