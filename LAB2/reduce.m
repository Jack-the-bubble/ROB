function rds = reduce(ds, parts)
% Funkcja redukcji liczby pr�bek poszczeg�lnych klas w zbiorze ds
% ds - zbi�r danych do redukcji; pierwsza kolumna zawiera etykiet�
% parts - wierszowy wektor wsp��czynnik�w redukcji dla poszczeg�lnych klas

	labels = unique(ds(:,1));
	if rows(labels) ~= columns(parts)
		error("Liczba klas nie zgadza sie z liczba wsp. redukcji.");
	end

	if max(parts) > 1 || min(parts) < 0
		error("Niewlasciwe wspolczynniki redukcji.");
	end
		
	% zdecydowanie wypadaloby uzyc randperm do mieszania probek w klasach
	% ta implementacja jest daleka od doskonalosci
	rds = [];
  %dla każdej klasy
  for classID=1: rows(labels)
    pom = [];
    %wybierz tylko jedną klasę do zredukowania
    pom = ds(ds(:, 1)==labels(classID), :);
    
    %
    perms = floor(parts(classID)*rows(pom));
    %pomieszaj zbiór
    pom_rows=randperm(rows(pom), perms);
    %obetnij próbki z każdej klasy i wrzuć do wyniku
    rds = [rds; pom(pom_rows,:)];
end