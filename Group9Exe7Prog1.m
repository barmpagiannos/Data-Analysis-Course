% Group9Exe7Prog2       - ELEGXOS SPIKE (+/-) / EPILOGH DIAGRAFHS GRAMMWN
% Demitsoglou Panagiwths
% Barmpagiannos Vasileios


clc, clearvars,close all;

% Fortwnw to arxeio TMS.xlsx ypo th morfh pinaka kai epilgw ta dedomena mou.
dataM = readmatrix('TMS.xlsx');

% Gia na vgaleis thn sthlh Spike ektos --> spikeout=true
spikeout=false;

if spikeout, dataM(:,8)=[]; end % Afairesi ths metavlitis Spike
TMS=dataM(:,1);
dataM=dataM(TMS==1,:);

% An epilejeis afairesh twn grammwn pou eina kena NanOut=true
NanOut=true;

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
train_dataM = dataM(train_idx, :); % Dedomena gai trainning
test_dataM = dataM(test_idx,:);  % Dedomena gia Testing
X_train = train_dataM(:,5:end);
y_train = train_dataM(:,2);
X_test  = test_dataM(:,5:end); 
y_test  = test_dataM(:,2);

%% ---------------- Full Model ----------------------------------------
% Orizoume ejarthmenh metavliti thn EDduration kai tiws loipes ws
% anejarthtes.

mdl_full = fitlm(X_train,y_train,"interactions");
yhat_full = predict(mdl_full, X_test);
adjR2_full=mdl_full.Rsquared.Adjusted;
MSE_full = mdl_full.MSE;
yM=y_test;
e_full=yM-yhat_full;
estar_full=e_full/std(e_full,"omitmissing");

figure
plot(yM,yhat_full,'.')
hold on
plot(yM,yM,'r--')
xlabel('y')
ylabel('$\hat{y}$','Interpreter','Latex')
title(sprintf('Full Model - No Spike - adjR^2=%1.4f - MSE=%.2f',adjR2_full,MSE_full));

% Diagnostiko Grafima ( Diagnostic Plot) --  (e*-y)
figure
clf
plot(yhat_full,estar_full,'.','Markersize',10)
hold on
plot(xlim,1.96*[1 1],'--c')
plot(xlim,-1.96*[1 1],'--c')
xlabel('y')
ylabel('e^*')
title('Full Model Diagnostic plot')


%% ---------------- StepWise Regression ----------------
mdl_sw = stepwiselm(X_train,y_train,'interactions');
yhat_sw = predict(mdl_sw, X_test);
adjR2_sw = mdl_sw.Rsquared.Adjusted;
yM=y_test;
% mse_sw2 = mean((yM - yhat_sw).^2,"omitmissing");
MSE_sw =mdl_sw.MSE;
e_ws=yM-yhat_sw;

% Diagramma (yhat-y) problepomenhs - deigmatikhs timis 
figure
plot(yM,yhat_sw,'.')
hold on
plot(yM,yM,'r--')
xlabel('y')
ylabel('$\hat{y}$','Interpreter','Latex')
title(sprintf('StepWise (SW) Model - No Spike - adjR^2=%1.4f - MSE=%.2f',adjR2_sw,MSE_sw));

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
MSE_LASSO=FitInfo.MSE(ilmin); % Epilegoume to MSE gia to sygkekrimeno lambda
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
title(sprintf('LASSO - No Spike - adjR^2=%1.4f - MSE=%.2f',adjR2_LASSO,MSE_LASSO))

figure
plot(yM,eLASSO/std(eLASSO,"omitmissing"),'.','Markersize',10)
hold on
plot(xlim,1.96*[1 1],'--c')
plot(xlim,-1.96*[1 1],'--c')
xlabel('y')
ylabel('e^*')
title('LASSO Diagnostic plot')




%% RESULTS

% SYMPERASMA: Apo ta tria montela, to kalutero adjR2 to exei to stepwise
% montelo. Epishs exei paromoio MSE me to full model alla den mas apasxolei
% afou exei megalutero adjR2. Gia to lasso oute logos afou to adjR2 einai
% sxedon mhden. Ara to montelo stepwise provlepei kalutera.

% ---------------- Apotelesmata ----------------
fprintf('\n\n--------------------Results--------------------\n');
fprintf('Full Model \t\t  MSE: %.2f \t adjR2: %.3f \n', MSE_full,adjR2_full);
fprintf('StepWise Model \t  MSE: %.2f \t adjR2: %.3f \n', MSE_sw,adjR2_sw);
fprintf('LASSO Model \t  MSE: %.2f \t adjR2: %.3f \n', MSE_LASSO,adjR2_LASSO);
fprintf('--------------------end-------------------------\n')
fprintf('SpikeOut=%d  ............  NanOut=%d \n\n',spikeout,NanOut);


% NOTES 
%
%
% --------------------Results--------------------
% Full Model 		  MSE: 157.34 	 adjR2: 0.317 
% StepWise Model 	  MSE: 54.92 	 adjR2: 0.324 
% LASSO Model    	  MSE: 80.63 	 adjR2: -0.016 
% --------------------end-------------------------
% SpikeOut=1  ............  NanOut=0 
% 
% --------------------Results--------------------
% Full Model 		  MSE: 57.05 	 adjR2: 0.294 
% StepWise Model 	  MSE: 54.02 	 adjR2: 0.332 
% LASSO Model    	  MSE: 83.02 	 adjR2: 0.921 
% --------------------end-------------------------
% SpikeOut=0  ............  NanOut=0 
% 
% --------------------Results--------------------
% Full Model 		  MSE: 43.80 	 adjR2: 0.192 
% StepWise Model 	  MSE: 43.11 	 adjR2: 0.205 
% LASSO Model    	  MSE: 54.56 	 adjR2: -0.010 
% --------------------end-------------------------
% SpikeOut=0  ............  NanOut=1 
% 

