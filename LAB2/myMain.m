% malutki plik do uruchomienia funkcji pdf
load pdf_test.txt
size(pdf_test)

% ile jest klas?
labels = unique(pdf_test(:,1))

% ile jest próbek w ka¿dej klasie?
[labels'; sum(pdf_test(:,1) == labels')]
		  % ^^^ dobrze by³oby pomyleæ o tym wyra¿eniu

% jak uk³adaj¹ siê próbki?
plot2features(pdf_test, 2, 3)


