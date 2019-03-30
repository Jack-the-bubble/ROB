function lab = cls1nn(ts, x)
%1-NN classifier
%ts - training set(first column contains labels
%x - sample to be classified (contains no label)
%lab- x's nearest neighbour label
	features = ts(:, 2:end);
%	col = std(features-repmat(x, rows(ts), 1), [], 2);
%	[~, i]= min(col);
%	lab = ts(i, 1);
	sqdist = sumsq(ts(:, 2:end)-repmat(x, rows(ts), 1), 2);
	[mv mi] = min(sqdist);
	lab = ts(mi);

end


