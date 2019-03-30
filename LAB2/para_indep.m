function para = para_indep(ts)
% Liczy parametry dla funkcji pdf_indep
% ts zbiór ucz¹cy (próbka = wiersz; w pierwszej kolumnie etykiety)
% para - struktura zawieraj¹ca parametry:
%	para.labels - etykiety klas
%	para.mu - wartoci rednie cech (wiersz na klasê)
%	para.sig - odchylenia standardowe cech (wiersz na klasê)

	labels = unique(ts(:,1));
	para.labels = labels;
	para.mu = zeros(rows(labels), columns(ts)-1);
	para.sig = zeros(rows(labels), columns(ts)-1);

	% tu trzeba wype³niæ wartoci rednie i odchylenie standardowe dla klas

	%((sqrt(cov(ts(ts(:,1) == labels(1), 2:end), ts(ts(:,1) == labels(1),2:end)))(eye(rows(labels))==1)))'
	for i = 1:rows(labels)
		%liczenie sredniej
		para.mu(i, :)=mean(ts(ts(:,1) == labels(i), 2:end));
		%liczenie odchylenia
		%wybiera próbki o tych samych labelach w każdej iteracji i liczy kovariancję, następnie spłaszcza macierz do wektora
		%para.sig(i, :) = ((sqrt(cov(ts(ts(:,1) == labels(i), 2:end), ts(ts(:,1) == labels(i),2:end)))(eye(rows(labels))==1)));
		para.sig(i, :) = std(ts(ts(:,1) == labels(i), 2:end));
	end
	
end



