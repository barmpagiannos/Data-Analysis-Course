% Group9Exe8Prog3      
% Demitsoglou Panagiwths
% Barmpagiannos Vasileios

% Pros8esame th metavlhth preTMS kai postTMS, valame epilogh na epilegeis
% an thes na symperilamvaneis th metavlhth SPIKE kathws kai an thes na
% lamvaneis ypopsi sou tis NaN times.

clc, clearvars ,close all;

% Fortwnw to arxeio TMS.xlsx ypo th morfh pinaka kai epilgw ta dedomena mou.
T = readmatrix("TMS.xlsx");

% Gia na vgaleis thn sthlh Spike ektos --> spikeout=true
spikeout=true;

if spikeout, T(:,8)=[]; end % Afairesi ths metavlitis Spike
TMS=T(:,1);
T=T(TMS==1,:); % Filtraroume ta dedomena gia mono me xrhsh TMS

% An epilejeis afairesh twn grammwn pou eina kena NanOut=true
NanOut=true;

if NanOut && ~spikeout
    T=T((~isnan(T(:,8))),:); % Afairese oles tis grammes opou h timh sth sthlh Spike einai NaN
end



xM=T(:,3:end);% epeleje ta dedomena twn 8 anejartitwn metablhtwn.
yM=T(:,2);    % epeleje thn ejarthmenh metavlhth, EDduration me TMS.

[n,p] = size(xM);

% Arxika tha kentraroume ta dedomena mas.
mx = mean(xM,"omitmissing"); % 1os tropos filtrarismatos --> nanmean(xM);
xcM = xM - mx; % centered data matrix X
my = mean(yM,"omitmissing"); % 2os tropos filtrarismatos
ycM = yM - my;  % centered data matrix Y

%% PLHRES MONTELO GRAMMIKIS PALINDROMHSHS
% Plires montelo me oles tis metavlites

mdl_full = fitlm(xcM, ycM);

bfull=mdl_full.Coefficients.Estimate;
yhat_full=[ones(n,1) xM]* bfull;  % Apeytheias --> predict(mdl_full, xM)
eFull=yM-yhat_full;
se=std(eFull,"omitmissing");
estar_full=eFull/se; % Ypologismos e*
MSE_full = mdl_full.MSE; % Ypologismos MSE
adjR2_full=mdl_full.Rsquared.Adjusted; % adjR^2
nmetvl_full=size(xM,2);

% Parakato emfanizoume ta diagrammata gia na vgaloume symperasmata

% Diagramma (yhat-y) problepomenhs - deigmatikhs timis 
figure
plot(yM,yhat_full,'.')
hold on
plot(yM,yM,'r--')
xlabel('y')
ylabel('$\hat{y}$','Interpreter','Latex')
title(sprintf('Full Model adjR^2=%1.4f - MSE=%.2f',adjR2_full,MSE_full));

% Diagnostiko Grafima ( Diagnostic Plot) --  (e*-yhat)
figure
clf
plot(yhat_full,estar_full,'.','Markersize',10)
hold on
plot(xlim,1.96*[1 1],'--c')
plot(xlim,-1.96*[1 1],'--c')
xlabel('y')
ylabel('e^*')
title('Full Model Diagnostic plot')



%% VHMATIKH PALINDROMHSH
% Parkato tha xrhsimopoihsoume montelo epiloghs metavlhtwn me thn methodo
% ths vhmatikhs palindromisis


mdl_sw = stepwiselm(xM, yM);

% Provlepomenes times (y_hat) kai typopoihmeno sfalma (e*)
yhat_sw = mdl_sw.Fitted; 
% Enallaktika -- 
% yhat_sw2 = predict(mdl_sw, xM);
eSW=yM-yhat_sw;
se=std(eSW,"omitmissing");
estar_sw=eSW/se;

MSE_sw = mdl_sw.MSE; % Ypologismos MSE
adjR2_sw=mdl_sw.Rsquared.Adjusted; % adjR^2
nmetvl_sw=length(mdl_sw.PredictorNames);


% Parakato emfanizoume ta diagrammata gia na vgaloume symperasmata

% Diagramma (yhat-y) problepomenhs - deigmatikhs timis 
figure
plot(yM,yhat_sw,'.')
hold on
plot(yM,yM,'r--')
xlabel('y')
ylabel('$\hat{y}$','Interpreter','Latex')
title(sprintf('StepWise (SW) Model adjR^2=%1.4f - MSE=%.2f',adjR2_sw,MSE_sw));

% Diagnostiko Grafima ( Diagnostic Plot) --  (e*-yhat)
figure
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

% Auto epilogh
% Epilogh ws to lambda opou to MSE einai to elaxisto
ilmin = FitInfo.IndexMinMSE; % Xrhsimopoihse gia lambda to MinMSE

bLASSO = B(:,ilmin);
bLASSO = [my - mx*bLASSO; bLASSO];
yhat_LASSO = [ones(n,1) xM] * bLASSO; 
eLASSOV = yhat_LASSO - yM;     % Ypologise ta ypoloipa (residuals-erros)
Syyhat2 = sum(eLASSOV.^2,"omitmissing");
Symy2=sum((yM-my).^2);
R2LASSO = 1 - Syyhat2/Symy2;
k=length(bLASSO(bLASSO~=0));  % A(A ~= 0)
adjR2_LASSO = 1 - (n-1)/(n-(k+1))*Syyhat2/Symy2; % adjR^2
MSE_LASSO=FitInfo.MSE(ilmin); % Epilegoume to MSE gia to sygkekrimeno lambda
nmetvl_lasso=k;


% Diagramma (yhat-y) problepomenhs - deigmatikhs timis 
figure
clf
plot(yM,yhat_LASSO,'.')
hold on
plot(yM,yM,'r-')
xlabel('y')
ylabel('$\hat{y}$','Interpreter','Latex')
title(sprintf('LASSO adjR^2=%1.4f - MSE=%.2f',adjR2_LASSO,MSE_LASSO));

% Diagnostiko Grafima ( Diagnostic Plot) --  (e*-yhat)
figure
plot(yhat_LASSO,eLASSOV/std(eLASSOV,"omitmissing"),'.','Markersize',10)
hold on
plot(xlim,1.96*[1 1],'--c')
plot(xlim,-1.96*[1 1],'--c')
xlabel('y')
ylabel('e^*')
title('LASSO Diagnostic plot')




%%  PCR regression

Symy2_pcr = sum((yM-mean(yM)).^2);

% Centering the predictor and response data
% mx = mean(xM);
% xcM = xM - repmat(mx,n,1); % centered data matrix
% my = mean(yM);
% ycM = yM - my;

[uM,sigmaM,vM] = svd(xcM,'econ',"matrix");


% Epilogi twn protwn k synistoswn poy ejhgoyn to 95%
explained_variance = diag(sigmaM).^2 / sum(diag(sigmaM).^2) * 100; % Pososto diakymanshs
d = find(cumsum(explained_variance) >= 95, 1); 


lambda = zeros(p,1);
lambda(1:d) = 1;
bPCR = vM * diag(lambda) * inv(sigmaM) * uM'* ycM;
bPCR = [my - mx*bPCR; bPCR];
yhat_pcr = [ones(n,1) xM] * bPCR; 
ePCR = yhat_pcr - yM;     % Calculate residuals
Syyhat2 = sum(ePCR.^2,"omitmissing");
R2_pcr = 1 - Syyhat2/Symy2_pcr;
adjR2_pcr = 1 - ((1 - R2_pcr) * (n - 1) / (n - p - 1));
MSE_pcr=mean(ePCR.^2,"omitmissing");
nmetvl_pcr = d;

% Diagramma (yhat-y) problepomenhs - deigmatikhs timis 
figure
plot(yM,yhat_pcr,'.')
hold on
plot(yM,yM,'r-')
xlabel('y')
ylabel('$\hat{y}$','Interpreter','Latex')
title(sprintf('PCR Model adjR^2=%1.4f - MSE=%.2f',adjR2_pcr,MSE_pcr));


% Diagnostiko Grafima ( Diagnostic Plot) --  (e*-yhat)
figure
plot(yhat_pcr,ePCR/std(ePCR,"omitmissing"),'.','Markersize',10)
hold on
plot(xlim,1.96*[1 1],'--c')
plot(xlim,-1.96*[1 1],'--c')
xlabel('y')
ylabel('e^*')
title('PCR')




%% RESULTS

% ---------------- Apotelesmata ----------------
fprintf('--------------------Results--------------------\n');
fprintf('Full Model \t\t  MSE: %.2f \t adjR2: %.3f \t #Vars=%d \n',MSE_full,adjR2_full,nmetvl_full);
fprintf('StepWise Model \t  MSE: %.2f \t adjR2: %.3f \t #Vars=%d \n', MSE_sw,adjR2_sw,nmetvl_sw);
fprintf('LASSO Model \t  MSE: %.2f \t adjR2: %.3f \t #Vars=%d \n', MSE_LASSO,adjR2_LASSO,nmetvl_lasso);
fprintf('PCR Model \t\t  MSE: %.2f \t adjR2: %.3f \t #Vars=%d \n', MSE_pcr,adjR2_pcr,nmetvl_pcr);
fprintf('--------------------end-------------------------\n');
fprintf('SpikeOut=%d  ............  NanOut=%d \n\n',spikeout,NanOut);


% SYMPERASMA: Otan vazoume kai thn metavlhth postTMS, kai ta tria montela
% dinoyn adjR2 ~1 kai MSE ~0, ara prosarmozontai teleia.

% NOTES
%
% 
% % --------------------Results--------------------
% % Full Model 		  MSE: 0.00 	 adjR2: 1.000 	 #Vars=7 
% % StepWise Model 	  MSE: 0.00 	 adjR2: 1.000 	 #Vars=6 
% % LASSO Model 	  MSE: 0.17 	 adjR2: 0.999 	 #Vars=3 
% % PCR Model 		  MSE: 0.00 	 adjR2: 1.000 	 #Vars=4 
% % --------------------end-------------------------
% % SpikeOut=1  ............  NanOut=0 
% % 
% % 
% % --------------------Results--------------------
% % Full Model 		  MSE: 0.00 	 adjR2: 1.000 	 #Vars=8 
% % StepWise Model 	  MSE: 0.00 	 adjR2: 1.000 	 #Vars=7 
% % LASSO Model 	  MSE: 0.07 	 adjR2: 0.999 	 #Vars=3 
% % PCR Model 		  MSE: 0.00 	 adjR2: 1.000 	 #Vars=4 
% % --------------------end-------------------------
% % SpikeOut=0  ............  NanOut=1 
% % 
% % --------------------Results--------------------
% % Full Model 		  MSE: 0.00 	 adjR2: 1.000 	 #Vars=8 
% % StepWise Model 	  MSE: 0.00 	 adjR2: 1.000 	 #Vars=7 
% % LASSO Model 	  MSE: 0.07 	 adjR2: 1.000 	 #Vars=3 
% % PCR Model 		  MSE: NaN	 	 adjR2: 1.000 	 #Vars=    <--- NaN cannot handled !!!
% % --------------------end-------------------------
% % SpikeOut=0  ............  NanOut=0 
% % 





