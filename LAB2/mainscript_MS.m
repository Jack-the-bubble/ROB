%mainscript_MS

% ładowanie danych
load train.txt
load test.txt

% zmiana etykiet na pasujące do populacji
for i=77:152:1824
	train(i:i+75,1) += 4;
	test(i:i+75,1) += 4;
end

%zebranie etykiet
labels = unique(train(:,1))

display(['Zadanie 2. Usuwanie wartości odstających:'])

%sprawdzenie wartości 186 i 642

probki = [186 642]

 for i =1:columns(probki)
   train(probki(i)-1:probki(i)+1, :)
 end
 
 display(["Powyższe próbki znacznie odstają dla wielu cech, więc zostaną usunięte"])
 
 for i=1:columns(probki)
    train(probki(1,i),:)=[];
 end
 
 display(["      Wielkość zbioru uczącego po usunięciu próbek:  " num2str(size(train))])
 
 display(["Zadanie 3. Klasyfikator optymalny Bayesa"])
 
 display([" Zredukowano do następujących cech:"])
 plot2features(train, 2,4);
 cechy = [2 4];
 
 
 
 
 
 
 display([num2str(cechy-1)])
 
 %ucięcie niepotrzebnych cech
 train = train(:, [1 cechy]);
 test = test(:, [1 cechy]);
 
 
 
 %prawdopodobieństwo apriori:
 apriori = [0.125 0.125 0.125 0.125 0.125 0.125 0.125 0.125];
 
 pdfindep_para = para_indep(train);
 pdfmulti_para = para_multi(train);
 pdfparzen_para = para_parzen(train, 0.001); 
 %podać w sprawozdaniu szerokość okna
 
 
 base_ercf = zeros(1,3);
 base_ercf(1) = mean(bayescls(test(:,2:end), @pdf_indep, pdfindep_para, apriori) != test(:,1));
 base_ercf(2) = mean(bayescls(test(:,2:end), @pdf_multi, pdfmulti_para, apriori) != test(:,1));
 base_ercf(3) = mean(bayescls(test(:,2:end), @pdf_parzen, pdfparzen_para, apriori) != test(:,1));
 base_ercf
 
 display(["Zadanie 4. Wpływ doboru próbek na klasyfikację zbioru testowego"])
 
 parts = [0.1 0.25 0.5];
 rep_cnt = 5; % przynajmniej
 
 indep.res = zeros(rep_cnt, columns(parts));
 indep.min = ones(1, columns(parts))*1000000;
 indep.max = zeros(1, columns(parts));
 indep.mean = zeros(1, columns(parts));
 indep.sig = zeros(1, columns(parts));
 
 multi.res = zeros(rep_cnt, columns(parts));
 multi.min = ones(1, columns(parts))*1000000;
 multi.max = zeros(1, columns(parts));
 multi.mean = zeros(1, columns(parts));
 multi.sig = zeros(1, columns(parts));
 
 parzen.res = zeros(rep_cnt, columns(parts));
 parzen.min = ones(1, columns(parts))*1000000;
 parzen.max = zeros(1, columns(parts));
 parzen.mean = zeros(1, columns(parts));
 parzen.sig = zeros(1, columns(parts));
 
 %kolejne redukcje zbioru uczącego
 
 for p=1:columns(parts)
 
   %
   for r=1:rep_cnt
     %redukcja zbioru uczącego
     clparts = ones(1,rows(labels))*parts(p);
     %w każdej iteracji losowany jest nowy zbiór zredukowany
     train_tmp = reduce(train,clparts);
     
     %wyznaczanie gęstości prawdopodobieństwa dla zbioru zredukowanego
     pdfindep_para = para_indep(train_tmp);
     pdfmulti_para = para_multi(train_tmp);
     pdfparzen_para = para_parzen(train_tmp, 0.001); 
     
     %klasyfikacja bayesa dla zbioru zredukowanego i obliczonych powyżej parametrów
     indep.res(r,p) = mean(bayescls(test(:,2:end), @pdf_indep, pdfindep_para, apriori) != test(:,1));
     multi.res(r,p) = mean(bayescls(test(:,2:end), @pdf_multi, pdfmulti_para, apriori) != test(:,1));
     parzen.res(r,p) = mean(bayescls(test(:,2:end), @pdf_parzen, pdfparzen_para, apriori) != test(:,1)); 
   end
   
   %wyznaczenie wartości minimalnych, maksymalnych i odchylenia standardowego
   indep.min(1,p) = min(indep.res(:,p));
   indep.max(1,p) = max(indep.res(:,p));
   indep.mean(1,p) = mean(indep.res(:,p));
   indep.sig(1,p) = std(indep.res(:,p));
   
   multi.min(1,p) = min(multi.res(:,p));
   multi.max(1,p) = max(multi.res(:,p));
   multi.mean(1,p) = mean(multi.res(:,p));
   multi.sig(1,p) = std(multi.res(:,p));
   
   parzen.min(1,p) = min(parzen.res(:,p));
   parzen.max(1,p) = max(parzen.res(:,p));
   parzen.mean(1,p) = mean(parzen.res(:,p));
   parzen.sig(1,p) = std(parzen.res(:,p));
   display(["||||| część zbioru:  " num2str(parts(p))])
   display([">>>uśrednione wyniki:  "])
   display(["---niezależne: " num2str(indep.mean(1,p))])
   display(["---wielowymiarowe: " num2str(multi.mean(1,p))])
   display(["---Parzen: " num2str(parzen.mean(1,p))])
   display([">>>odchylenie standardowe:  "])
   display(["---niezależne: " num2str(indep.sig(1,p))])
   display(["---wielowymiarowe: " num2str(multi.sig(1,p))])
   display(["---Parzen: " num2str(parzen.sig(1,p))])
   
 end
 
 
 
 
 
 display(["Zadanie 5. Wpływ parametru h1 na klasyfikację zbioru testowego"])
 parzen_widths = [0.0001, 0.0005, 0.001, 0.005, 0.01];
 parzen_res = zeros(1, columns(parzen_widths));
 
 for i=1:columns(parzen_widths)
 
   pdfparzen_para = para_parzen(train, parzen_widths(1,i)); 
   parzen_res(1,i) = mean(bayescls(test(:,2:end), @pdf_parzen, pdfparzen_para, apriori) != test(:,1)); 
   display([">>>>>>szerokość okna:  " num2str(parzen_widths(i))])
   display(["      współczynnik błedu:  " num2str(parzen_res(1,i))])
 end
 
 %[parzen_widths; parzen_res]
 semilogx(parzen_widths, parzen_res)
 
 
 
 display(["Zadanie 6. Wpływ prawdopodobieństw apriori na wyniki klasyfikacji"])
 
 apriori = [0.165 0.085 0.085 0.165 0.165 0.085 0.085 0.165];
 parts = [1.0 0.5 0.5 1.0 1.0 0.5 0.5 1.0];
 
 %inicjalizacja wartości wynikowych
 rec_cnt = 5;
 indep.res = zeros(1,rep_cnt);
 indep.min = 999999;
 indep.max = 0;
 indep.mean = 0;
 indep.sig = 0;
 
 multi.res = zeros(1,rep_cnt);
 multi.min = 999999;
 multi.max = 0;
 multi.mean = 0;
 multi.sig = 0;
 
 parzen.res = zeros(1,rep_cnt);
 parzen.min = 999999;
 parzen.max = 0;
 parzen.mean = 0;
 parzen.sig = 0;
 
 pdfindep_para = para_indep(train);
 pdfmulti_para = para_multi(train);
 pdfparzen_para = para_parzen(train, 0.001); 
 
 for r=1:rep_cnt
   test_pom = reduce(test,parts);
  
   indep.res(1,r) = mean(bayescls(test_pom(:,2:end), @pdf_indep, pdfindep_para, apriori) != test_pom(:,1));
   multi.res(1,r) = mean(bayescls(test_pom(:,2:end), @pdf_multi, pdfmulti_para, apriori) != test_pom(:,1));
   parzen.res(1,r) = mean(bayescls(test_pom(:,2:end), @pdf_parzen, pdfparzen_para, apriori) != test_pom(:,1));
 end
 %wyznaczenie interesujących nas wyników
 
 indep.min = min(indep.res);
 indep.max = max(indep.res);
 indep.mean = mean(indep.res);
 indep.sig = std(indep.res);
 
 multi.min = min(multi.res);
 multi.max = max(multi.res);
 multi.mean = mean(multi.res);
 multi.sig = std(multi.res);
 
 parzen.min = min(parzen.res);
 parzen.max = max(parzen.res);
 parzen.mean = mean(parzen.res);
 parzen.sig = std(parzen.res);
 
 display(["---niezależne: " num2str(indep.mean)])
 display(["---wielowymiarowe: " num2str(multi.mean)])
 display(["---Parzen: " num2str(parzen.mean)])
 
 
 display(["Zadanie 7. klasyfikacja 1-NN"])
 
 %If there is big difference in standard deviations between features 
 %you should normalize data before classification.
 
 %sprawdzenie różnic w odchyleniach standardowych między poszczególnymi cechami
 %tylko cechy wybrane uprzednio
 display([">>>>Różnica Odchyleń standardowych dla wybranych cech ze zbioru uczącego"])
 
 abs(std(train(:,2)-std(train(:, 3))))
 
 display([">>>>różnica ma jeden rząd wielkości - potrzebna normalizacja"])
 train_1=train;
 test_1=test;
 
 display([">>>>różnica w odchyleniach standardowych po normalizacji"])
 
 
 for i=2:columns(train)
   subtract = mean(train(:,i));
   divide = std(train(:,i));
   train_1(:,i)=(train(:,i)-subtract)/divide;
   test_1(:,i)=(test(:,i)-subtract)/divide;
 end
 
 abs(std(train_1(:,2))-std(train_1(:, 3)))
 
 error = 0;
 
 display([">>>>Błąd przed normalizacją"])
 
 for i=1:rows(test)
   error=error+(cls1nn(train,test(i,2:end)) != test(i,1));  
 end
 error=error/rows(test)
 
 display([">>>>Błąd po normalizacji"])
 
 error=0;
 for i=1:rows(test)
   error=error+(cls1nn(train_1,test_1(i,2:end)) != test_1(i,1));  
 end
 error=error/rows(test)
 
