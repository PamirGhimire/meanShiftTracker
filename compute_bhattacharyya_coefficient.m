function bdist = compute_bhattacharyya_coefficient(targetmodel, colormodel)

productModel = sqrt(targetmodel .* colormodel);
bdist = sum(productModel);

end
