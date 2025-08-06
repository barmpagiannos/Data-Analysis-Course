% Group9Exe6Prog1           
% Demitsoglou Panagiwths
% Barmpagiannos Vasileios

% Me th metavlhth Spike alla me afairesh twn NaN parathrhsewn.

clc, clearvars ,close all;

% Fortwnw to arxeio TMS.xlsx ypo th morfh pinaka kai epilgw ta dedomena mou.
T = readmatrix("TMS.xlsx");
% T(:,8)=[]; % Vgale ektos thn sthlh Spike
TMS=T(:,1); % TMS=1 se xrisi, TMS=0 xwris

% AN THELOUME NA VGALOUME EKTOS TIS NaN GRAMMES NaNOut=1.
NanOut=1;
% Afairwntas tis NaN grammes, ta dedomena mas meiwnontai kata 22
% parathrhseis.

if NanOut==1
    data=T((~isnan(T(:,8)) & TMS==1),:); % Afairese oles tis grammes opou h timh sth sthlh Spike einai NaN
else
    data=T((TMS==1),:); % Epilogh mono me TMS stoixeia xwris aferaish NaN grammwn 
                        % Mhn tis lamvaneis ypopsin, "omitmissing"
end


xM=data(:,5:end);% epeleje ta dedomena twn 5 anejartitwn metablhtwn.
yM=data(:,2);    % epeleje thn ejarthmenh metavlhth, EDduration me TMS.

[n,p] = size(xM);

% Arxika tha kentraroume ta dedomena mas.
mx = mean(xM,"omitmissing"); % 1os tropos filtrarismatos --> nanmean(xM);
xcM = xM - mx; % centered data matrix X
my = mean(yM,"omitmissing"); % 2os tropos filtrarismatos
ycM = yM - my;  % centered data matrix Y

%% PLHRES MONTELO GRAMMIKIS PALINDROMHSHS
% Plires montelo me oles tis metavlites

mdl_full = fitlm(xM, yM);

bfull=mdl_full.Coefficients.Estimate;
%yhat_full=[ones(n,1) xM]* bfull;  % Apeytheias --> predict(mdl_full, xM)
yhat_full=predict(mdl_full, xcM);
eFull=yM-yhat_full;
se=std(eFull,"omitmissing");
estar_full=eFull/se; % Ypologismos e*
MSE_full = mdl_full.MSE; % Ypologismos MSE
adjR2_full=mdl_full.Rsquared.Adjusted; % adjR^2

% Parakato emfanizoume ta diagrammata gia na vgaloume symperasmata

% Diagramma (yhat-y) problepomenhs - deigmatikhs timis 
figure(1)
plot(yM,yhat_full,'.')
hold on
plot(yM,yM,'r--')
xlabel('y')
ylabel('$\hat{y}$','Interpreter','Latex')
title(sprintf('Full Model adjR^2=%1.4f - MSE=%.2f',adjR2_full,MSE_full));

% Diagnostiko Grafima ( Diagnostic Plot) --  (e*-y)
figure(2)
clf
plot(yhat_full,estar_full,'.','Markersize',10)
hold on
plot(xlim,1.96*[1 1],'--c')
plot(xlim,-1.96*[1 1],'--c')
xlabel('y')
ylabel('e^*')
title('Full Model Diagnostic plot')

% NOTES
%
%

%% VHMATIKH PALINDROMHSH
% Parkato tha xrhsimopoihsoume montelo epiloghs metavlhtwn me thn methodo
% ths vhmatikhs palindromisis


mdl_sw = stepwiselm(xcM, ycM);

% bsw=mdl_sw.Coefficients.Estimate;
% bsw = [my - mx*bsw; bsw]; % --->  Xekentrarei to dianisma b
% yhat_sw2=[ones(n,1) xM]* bsw;

% Provlepomenes times (y_hat) kai typopoihmeno sfalma (e*)
yhat_sw = mdl_sw.Fitted; % Enallaktika --> predict(mdl_full, xM)
eSW=yM-yhat_sw;
se=std(eSW,"omitmissing");
estar_sw=eSW/se;

MSE_sw = mdl_sw.MSE; % Ypologismos MSE
adjR2_sw=mdl_sw.Rsquared.Adjusted; % adjR^2


% Parakato emfanizoume ta diagrammata gia na vgaloume symperasmata

% Diagramma (yhat-y) problepomenhs - deigmatikhs timis 
figure(3)
plot(yM,yhat_sw,'.')
hold on
plot(yM,yM,'r--')
xlabel('y')
ylabel('$\hat{y}$','Interpreter','Latex')
title(sprintf('StepWise (SW) Model adjR^2=%1.4f - MSE=%.2f',adjR2_sw,MSE_sw));

% Diagnostiko Grafima ( Diagnostic Plot) --  (e*-y)
figure(4)
plot(yhat_sw,estar_sw,'.','Markersize',10)
hold on
plot(xlim,1.96*[1 1],'--c')
plot(xlim,-1.96*[1 1],'--c')
xlabel('y')
ylabel('e^*')
title('StepWise(SW) Model Diagnostic plot')



%% METHODOS LASSO (Meiwsh metavlhtwn)

[B,FitInfo] = lasso(xcM,ycM,'CV',10);
mdl_lasso = struct('Coefficients', B, 'FitInfo', FitInfo);
lassoPlot(B,FitInfo,'PlotType','CV','XScale','log'); % 'PlotType','CV' h  'Lambda'
lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log'); % 'PlotType','CV' h  'Lambda'

% Epelexe lamda

% Manual epilogh
% lambda = input('Give lambda > ');
% [lmin, ilmin] = min(abs(FitInfo.Lambda - lambda));

ilmin = FitInfo.IndexMinMSE; % Xrhsimopoihse gia lambda to MinMSE

bLASSO = B(:,ilmin);
bLASSO = [my - mx*bLASSO; bLASSO];
yhat_LASSO = [ones(n,1) xM] * bLASSO; 
eLASSOV = yhat_LASSO - yM;     % Calculate residuals
Syyhat2 = sum(eLASSOV.^2,"omitmissing");
Symy2=sum((yM-my).^2,"omitmissing");
R2LASSO = 1 - Syyhat2/Symy2;
k=length(bLASSO(bLASSO~=0));  % A(A ~= 0)
adjR2_LASSO = 1 - (n-1)/(n-(k+1))*Syyhat2/Symy2; % adjR^2
% MSE_LASSO = mean((yM - yhat_LASSO).^2,"omitmissing"); % Ypologismos MSE
MSE_LASSO=FitInfo.MSE(ilmin); % Epilegoume to MSE gia to sygkekrimeno lambda


figure(5)
clf
plot(yM,yhat_LASSO,'.')
hold on
plot(yM,yM,'r-.')
xlabel('y')
ylabel('$\hat{y}$','Interpreter','Latex')
title(sprintf('LASSO adjR^2=%1.4f - MSE=%.2f',adjR2_LASSO,MSE_LASSO));

figure(6)
plot(yhat_LASSO,eLASSOV/std(eLASSOV,"omitmissing"),'.','Markersize',10)
hold on
plot(xlim,1.96*[1 1],'--c')
plot(xlim,-1.96*[1 1],'--c')
xlabel('y')
ylabel('e^*')
title('LASSO Diagnostic plot')



%% RESULTS

% ---------------- Apotelesmata ----------------
fprintf('\n\n--------------------Results--------------------\n');
fprintf('Full Model \t\t  MSE: %.2f \t adjR2: %.3f \n', MSE_full,adjR2_full);
fprintf('StepWise Model \t  MSE: %.2f \t adjR2: %.3f \n', MSE_sw,adjR2_sw);
fprintf('LASSO Model \t  MSE: %.2f \t adjR2: %.3f \n', MSE_LASSO,adjR2_LASSO);
fprintf('--------------------end-------------------------\n\n')

% SYMPERASMA: parathrw oti gia to montelo pou prokuptei apo th methodo
% vhmatikhs palindromhshs, o prosarmosmenos syntelesths prosdiorismou
% einai mikroteros kai h diaspora twn sfalmatwn einai paromoia, ara to
% montelo vhmatikhs palindromhshs prosarmozetai ligo xeirotera apo oti to plhres
% montelo.

% SYMPERASMA: me th methodo LASSO to adjR2 einai polu megalytero apo tis
% alles duo methodous, an kai to MSE vgainei ligo megalutero. Katalhktika
% to montelo lasso einai to kalytero apo ta alla dyo.

% --------------------Results-------------------- +SPIKE - NaN grammes ektos (ligotera data).
% Full Model 		  MSE: 62.08 	 adjR2: 0.041 
% StepWise Model 	  MSE: 62.36 	 adjR2: 0.036 
% LASSO Model 	      MSE: 64.53 	 adjR2: -0.011 
% --------------------end-------------------------
% 
% --------------------Results-------------------- -SPIKE
% Full Model 		  MSE: 110.93 	 adjR2: 0.243 
% StepWise Model 	  MSE: 83.75 	 adjR2: 0.428 
% LASSO Model 	      MSE: 120.33 	 adjR2: 0.229 
% --------------------end-------------------------
% 
% --------------------Results-------------------- + Spike - NaN mhnn tis lamvaneis ypopsin
% Full Model 		  MSE: 62.08 	 adjR2: 0.041 
% StepWise Model 	  MSE: 62.36 	 adjR2: 0.036 
% LASSO Model    	  MSE: 64.73 	 adjR2: 0.614 
% --------------------end-------------------------






