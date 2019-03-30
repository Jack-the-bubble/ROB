function pdf = pdf_parzen(pts, para)
% Aproksymuje warto�� g�sto�ci prawdopodobie�stwa z wykorzystaniem okna Parzena
% pts zawiera punkty, dla kt�rych liczy si� f-cj� g�sto�ci (punkt = wiersz)
% para - struktura zawieraj�ca parametry:
%	para.samples - tablica kom�rek zawieraj�ca pr�bki z poszczeg�lnych klas
%	para.parzenw - szeroko�� okna Parzena
% pdf - macierz g�sto�ci prawdopodobie�stwa
%	liczba wierszy = liczba pr�bek w pts
%	liczba kolumn = liczba klas

	pdf = rand(rows(pts), rows(para.samples));
	
	% przy liczeniu g�sto�ci warto zastanowi� si�
	% nad kolejno�ci� oblicze� (p�tli)
  for i = 1:rows(para.samples)
    %szerokosc okna
    hn= para.parzenw / sqrt(rows(para.samples{i}));
    %
    singlpdf = zeros(size(para.samples{i}));
    for j = 1:rows(pts)
      for ft = 1:columns(pts)
        singlpdf(:, ft) = normpdf(para.samples{i}(:, ft),pts(j, ft), hn);
      end
      pdf(j, i) = mean(prod(singlpdf, 2));
    end
  end
  
end
