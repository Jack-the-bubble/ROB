function pdf = pdf_indep(pts, para)
% Liczy funkcj� g�sto�ci prawdopodobie�stwa przy za�o�eniu, �e cechy s� niezale�ne
% pts zawiera punkty, dla kt�rych liczy si� f-cj� g�sto�ci (punkt = wiersz, bez etykiety!)
% para - struktura zawieraj�ca parametry:
%	para.mu - warto�ci �rednie cech (wiersz na klas�)
%	para.sig - odchylenia standardowe cech (wiersz na klas�)
% pdf - macierz g�sto�ci prawdopodobie�stwa
%	liczba wierszy = liczba pr�bek w pts
%	liczba kolumn = liczba klas

	% znam rozmiar wyniku, wi�c go alokuj�
	pdf = zeros(rows(pts), rows(para.mu));

  %normpdf(pdf_test(2, 2), 0.7970000, 0.21772)*normpdf(pdf_test(2, 3), 0.8200000, 0.19172)
  
	% tu trzeba policzy� warto�� funkcji g�sto�ci
  
	% jako iloczyn g�sto�ci jednowymiarowych
  onedpdf = zeros(rows(pts), columns(para.mu));
  
  %dla kazdej klasy
  for i = 1:rows(para.mu)
    %dla kazdej cechy
    for j = 1:columns(pts)
      %oblicz wektor gestosci prawdopodobienstwa
      onedpdf(:,j) = normpdf(pts(:,j), para.mu(i,j),para.sig(i,j));
    end
    %gestosc jest liczona jako iloczyn gestosci prawdopodobienstwa
    pdf(:,i) = onedpdf(:,1).*onedpdf(:,2);
  end
  
  
  
end