function pdf = pdf_multi(pts, para)
% Liczy funkcj� g�sto�ci prawdopodobie�stwa wielowymiarowego r. normalnego
% pts zawiera punkty, dla kt�rych liczy si� f-cj� g�sto�ci (punkt = wiersz)
% para - struktura zawieraj�ca parametry:
%	para.mu - warto�ci �rednie cech (wiersz na klas�)
%	para.sig - macierze kowariancji cech (warstwa na klas�)
% pdf - macierz g�sto�ci prawdopodobie�stwa
%	liczba wierszy = liczba pr�bek w pts
%	liczba kolumn = liczba klas
  cov = para.sig(:, :, 1)
  u = (para.mu(1,:))'
  n = columns(pts)
  X = pts'
  
	pdf = 1/((2*pi)^(n/2)*det(cov)^0.5)*exp(-0.5*(X-u)'*cov^(-1)*(X-u));
	
	% liczenie g�sto�ci upro�ci u�ycie funkcji mvnpdf
end
