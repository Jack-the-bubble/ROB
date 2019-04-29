% mainscript is rather short this time

% primary component count
comp_count = 150; 

%macierz z danymi & wektor etykiet & macierz z danymi & wektor etykiet
[tvec tlab tstv tstl] = readSets(); 

% let's look at the first digit in the training set
%imshow(1-reshape(tvec(1,:), 28, 28)');

% let's check labels in both sets
[unique(tlab)'; unique(tstl)']

% compute and perform PCA transformation
[mu trmx] = prepTransform(tvec, comp_count);
tvec = pcaTransform(tvec, mu, trmx);
tstv = pcaTransform(tstv, mu, trmx);



% let's shift labels by one to use labels directly as indices
%etykietą 0 jest 1, etykietą 1 jest 2 itp
tlab += 1;
tstl += 1;

% To successfully prepare ensemble you have to implement perceptron function
% I would use 10 first zeros and 10 fisrt ones 
% and only 2 first primary components
% It'll allow printing of intermediate results in perceptron function

%
% YOUR CODE GOES HERE - testing of the perceptron function
%inicjalizacja pierwszych dwóch komponentów
test_zer = tvec(tlab==1, :);
test_ones = tvec(tlab==2, :);
count = 5;
res = ones(count, 2);
for i = 1:count
  [a falsp falsn] = perceptron(test_zer, test_ones);
  fp_wsp = falsp/(falsp+(rows(test_ones)-falsn));
  fn_wsp = falsn/(falsn+(rows(test_zer) - falsp));
  res(i, :) = [fp_wsp fn_wsp];
end

mean(res)


#{
%przygotowanie glosowania 45 klasyfikatorow
% training of the whole ensemble
ovo = trainOVOensamble(tvec, tlab, @perceptron);
% check your ensemble on train set
clab = unamvoting(tvec, ovo);
cfmx = confMx(tlab, clab)
compErrors(cfmx)

%zapisanie klasyfikatorów
save("ovo_save.txt", "ovo");
#}

disp(['-------------wyniki referencyjne-------------']);
load("ovo_save.txt");
clab = unamvoting(tvec, ovo);
cfmx = confMx(tlab, clab);
compErrors(cfmx);




% repeat on test set
clab = unamvoting(tstv, ovo);
cfmx = confMx(tstl, clab)
compErrors(cfmx)


%
% YOUR CODE GOES HERE

%podzielenie cyfr na grupy
group_set = tlab;
grps= [1 4 6 9; 2 3 7 0; 5 8 10 0]; %labele powiększone o 1
for i =1:rows(grps)
    group_set(any(or(tlab==grps(i,:)), 2)) = i;
end

%przygotowanie zestawu klasyfikatorów
ovo_groups = trainOVOensamble(tvec, group_set, @perceptron);

disp(['confusion matrix i bledy ovo_groups'])
clab_groups = unamvoting(tvec, ovo_groups);
cfmx = confMx(group_set, clab_groups);
compErrors(cfmx);


% klasyfikacja cyfr w grupach
cfmxg = zeros(10,11);
% wyciagnij klasyfikatory dla 1 4 6 9, czyli 14 16 19 46 49 69 i tak samo dla kolejnych grup
for i=1:rows(grps)
  ovos = ovo(and(any(or(ovo(:,1) == grps(i,:)),2),any(or(ovo(:,2) == grps(i,:)),2)),:);
  ovos(:,1:2);
  clabs = unamvoting(tvec(clab_groups==i,:), ovos);
  computed_classes = zeros(size(clabs));
  for k=1:nnz(grps(i,:))
    computed_classes(clabs==k) = grps(i,k);
  end
  % najwieksza wartosc to odrzucenie, zmien na 11
  computed_classes(clabs==max(clabs)) = 11;
  cfmx = confMx(tlab(clab_groups==i,:), computed_classes);
  compErrors(cfmx)
  cfmxg+=cfmx;
end
cfmxg
compErrors(cfmxg)
