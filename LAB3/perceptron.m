function [sepplane posmiss negmiss] = perceptron(pclass, nclass)
% Computes separating plane (linear classifier) using
% perceptron method.
% pclass - 'positive' class (one row contains one sample)
% nclass - 'negative' class (one row contains one sample)
% Output:
% sepplane - row vector of separating plane coefficients
% posmiss - number (coefficient) of misclassified samples of pclass
% negmiss - number (coefficient) of misclassified samples of nclass

  sepplane = rand(1, columns(pclass) + 1) - 0.5;
  nPos = rows(pclass); % number of positive samples
  nNeg = rows(nclass); % number of negative samples
%wciskanie obu zestawów w jedną macierz
  tset = [ ones(nPos, 1) pclass; -ones(nNeg, 1) -nclass]; %denormalizacja
  
  prog = 0.001;

  i = 1;
  do 
	%%% YOUR CODE GOES HERE %%%
	%% You should:
	%% 1. Check which samples are misclassified (boolean column vector)
  missclass = tset*sepplane' < 0;
	%% 2. Compute separating plane correction 
	%%		This is sum of misclassfied samples coordinate times learning rate 
  n = 1/sqrt(i);
  corr = n*sum(tset(missclass, :));
	%% 3. Modify solution (i.e. sepplane)
  sepplane = sepplane + corr;
	%% 4. Optionally you can include additional conditions to the stop criterion
	%%		200 iterations can take a while and probably in most cases is unnecessary
  if(abs(corr) < prog)
    break;
  end
  
	++i;
  until i > 200;

  %%% YOUR CODE GOES HERE %%%
  %% You should:
  %% 1. Compute the numbers (coefficients) of misclassified positive 
  %%    and negative samples
  posmiss = sum([ones(rows(pclass), 1) pclass]*sepplane' < 0);
  negmiss = sum([ones(rows(nclass), 1) nclass]*sepplane' > 0);
