function para = para_indep(ts)
% Liczy parametry dla funkcji pdf_indep
% ts zbiór ucz¹cy (próbka = wiersz; w pierwszej kolumnie etykiety)
% para - struktura zawieraj¹ca parametry:
%	para.labels - etykiety klas
%	para.mu - wartoœci œrednie cech (wiersz na klasê)
%	para.sig - odchylenia standardowe cech (wiersz na klasê)

	labels = unique(ts(:,1));
	para.labels = labels;
	para.mu = zeros(rows(labels), columns(ts)-1);
	para.sig = zeros(rows(labels), columns(ts)-1);

	% tu trzeba wype³niæ wartoœci œrednie i odchylenie standardowe dla klas

	((sqrt(cov(ts(ts(:,1) == labels(1), 2:end), ts(ts(:,1) == labels(1),2:end)))(eye(rows(labels))==1)))'
	for i = 1:rows(labels)
		%liczenie sredniej
		para.mu(i, :)=mean(ts(ts(:,1) == labels(i), 2:end))
		%liczenie odchylenia

		para.sig(i, :) = ((sqrt(cov(ts(ts(:,1) == labels(i), 2:end), ts(ts(:,1) == labels(i),2:end)))(eye(rows(labels))==1)))
		
	end
	
end


%	para.sig = [sqrt(cov(c1(:,2),c1(:,2))), sqrt(cov(c1(:,3),c1(:,3)));sqrt(cov(c2(:,2),c2(:,2))), sqrt(cov(c2(:,3),c2(:,3)))];
