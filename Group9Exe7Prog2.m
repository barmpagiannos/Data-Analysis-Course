% Group9Exe7Prog3           - ELEGXOS SPIKE (+/-) / EPILOGH DIAGRAFHS GRAMMWN
% Demitsoglou Panagiwths
% Barmpagiannos Vasileios

%!!!!!!!!!!!
% SE AYTO TO PROGRAMMA THA KANOYME TRAINIG TA DEDOMENA APO TYXAIA EPILOGH
% DEDOMENWN ANEJARTHTWN METAVLHTWN KAI THA KANOYME TEST SE OLO TO DEIGMA
% !!!!!!!!!
clc, clearvars,close all;

% Fortwnw to arxeio TMS.xlsx ypo th morfh pinaka kai epilgw ta dedomena mou.
dataM = readmatrix('TMS.xlsx');

% Gia na vgaleis thn sthlh Spike ektos --> spikeout=true
spikeout=true;

if spikeout, dataM(:,8)=[]; end % Afairesi ths metavlitis Spike
TMS=dataM(:,1);
dataM=dataM(TMS==1,:);

% An epilejeis afairesh twn grammwn pou eina kena NanOut=true
NanOut=false;

if NanOut && ~spikeout
    dataM=dataM((~isnan(dataM(:,8))),:); % Afairese oles tis grammes opou h timh sth sthlh Spike einai NaN
end



%-------------------------------------------

% EPILOGH DEDOMENWN ME TYXAIOTHTA -----------------
rng(1); % Parametros gia randomization
n = height(dataM);
idx = randperm(n); % epilegoume xwris epanathesi deiktes apo 1:n , n-->synolo epilegmenwn parathrhsewn
train_ratio = 0.7; % epilego pososto epi twn dedomenwn mou
train_idx = idx(1:round(train_ratio * n)); % epilego avta pou kanv trainig ta montela mas
test_idx = idx(round(train_ratio * n) + 1:end); % epilego ta ypoloipa poy tha kano test

% Omadopoihse ta dedomena.
train_dataM = dataM(train_idx, :);
test_dataM = dataM;  % THA KANW TEST SE OLA TA DEDOMENA
X_train = train_dataM(:,5:end);
y_train = train_dataM(:,2);
X_test  = test_dataM(:,5:end); 
y_test  = test_dataM(:,2);


%% ---------------- StepWise Regression ----------------
mdl_sw = stepwiselm(X_train,y_train,'interactions');
yhat_sw = predict(mdl_sw, X_test);
adjR2_sw = mdl_sw.Rsquared.Adjusted;
yM=y_test;
% mse_sw2 = mean((yM - yhat_sw).^2,"omitmissing");
mse_sw =mdl_sw.MSE;
e_ws=yM-yhat_sw;

% Diagramma (yhat-y) problepomenhs - deigmatikhs timis 
figure
plot(yM,yhat_sw,'.')
hold on
plot(yM,yM,'r--')
xlabel('y')
ylabel('$\hat{y}$','Interpreter','Latex')
title(sprintf('StepWise (SW) Model - No Spike - adjR^2=%1.4f - MSE=%.2f',adjR2_sw,mse_sw));

% Diagnostiko Grafima ( Diagnostic Plot) --  (e*-y)
figure
plot(yM,e_ws/std(e_ws,"omitmissing"),'.','Markersize',10)
hold on
plot(xlim,1.96*[1 1],'--c')
plot(xlim,-1.96*[1 1],'--c')
xlabel('y')
ylabel('e^*')
title('StepWise(SW) Model Diagnostic plot')


%% ---------------- LASSO Regression ----------------

[B, FitInfo] = lasso(X_train, y_train, 'CV', 10); % Επιλογή λ με cross-validation  

% Emfanise ta LASSO plots kai epelexe katallhlo lambda
lassoPlot(B,FitInfo,'PlotType','CV','XScale','log'); % 'PlotType','CV' h  'Lambda'
lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log'); % 'PlotType','CV' h  'Lambda'

% Epilegoume katallhlo lambda
% lambda = input('Give lambda > ');
% [lmin, ilmin] = min(abs(FitInfo.Lambda - lambda));
ilmin = FitInfo.IndexMinMSE; % Xrhsimopoihse gia lambda to MinMS
%yhat_lasso = X_test * B(:, FitInfo.Index1SE) + FitInfo.Intercept(FitInfo.Index1SE);  % IndexMinMSE
yhat_lasso = X_test * B(:, ilmin) + FitInfo.Intercept(ilmin);
B1=B(:, ilmin);

% mse_LASSO = mean((y_test - yhat_lasso).^2);
mse_LASSO=FitInfo.MSE(ilmin); % Epilegoume to MSE gia to sygkekrimeno lambda
eLASSO=y_test - yhat_lasso;
my_test=mean(y_test,"omitmissing");
Symy2=sum((y_test-my_test).^2,"omitmissing");
Syyhat2 = sum(eLASSO.^2,"omitmissing");
R2LASSO = 1 - Syyhat2/Symy2;
k=length(B1(B1~=0));  % A(A ~= 0) --> Vres ta mh mhdenika stoixeia toy pinaka.
adjR2_LASSO = 1 - (n-1)/(n-(k+1))*Syyhat2/Symy2; % adjR^2

% Parakato Emfanise ta diagrammata elegxou
figure
plot(y_test,yhat_lasso,'.')
hold on
plot(y_test,y_test,'r-.')
xlabel('y')
ylabel('$\hat{y}$','Interpreter','Latex')
title(sprintf('LASSO - No Spike - adjR^2=%1.4f - MSE=%.2f',adjR2_LASSO,mse_LASSO))

figure
plot(yM,eLASSO/std(eLASSO,"omitmissing"),'.','Markersize',10)
hold on
plot(xlim,1.96*[1 1],'--c')
plot(xlim,-1.96*[1 1],'--c')
xlabel('y')
ylabel('e^*')
title('LASSO Diagnostic plot')




%% RESULTS

% ---------------- Apotelesmata ----------------
fprintf('\n\n--------------------Results--------------------\n');
fprintf('StepWise Model \t  MSE: %.2f \t adjR2: %.3f \n', mse_sw,adjR2_sw);
fprintf('LASSO Model \t  MSE: %.2f \t adjR2: %.3f \n', mse_LASSO,adjR2_LASSO);
fprintf('--------------------end-------------------------\n')
fprintf('SpikeOut=%d  ............  NanOut=%d \n\n',spikeout,NanOut);


% SYMPERASMA: Ta adjR2 kai MSE tou stepwise einai megalutero kai mikrotero antistoixa
% apo tou lasso, ara kai pali to stepwise montelo provlepei kalytera.
% Otan kanoyme test se OLO to deigma, exoume kalutero adjR2 gia to
% stepwise, alla megalutero MSE. To adjR2 tou lasso paramenei to idio mikro
% alla thetiko. To MSE tou lasso aujanetai epishs. Ara nai, ta apotelesmata
% einai diaforetika.

% NOTES 
%
%
% --------------------Results--------------------
% StepWise Model 	  MSE: 54.92 	 adjR2: 0.324 
% LASSO Model    	  MSE: 80.63 	 adjR2: 0.009 
% --------------------end-------------------------
% SpikeOut=1  ............  NanOut=0 
% 
%  --------------------Results--------------------
% StepWise Model 	  MSE: 54.02 	 adjR2: 0.332 
% LASSO Model    	  MSE: 83.02 	 adjR2: 0.639 
% --------------------end-------------------------
% SpikeOut=0  ............  NanOut=0 
% 
% --------------------Results--------------------
% StepWise Model 	  MSE: 43.11 	 adjR2: 0.205 
% LASSO Model    	  MSE: 54.56 	 adjR2: -0.002 
% --------------------end-------------------------
% SpikeOut=0  ............  NanOut=1 



