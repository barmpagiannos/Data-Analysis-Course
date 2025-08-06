% Group9Exe5Prog1
% Demitsoglou Panagiwths
% Barmpagiannos Vasileios
clc, clearvars ,close all;

% Fortwnw to arxeio TMS.xlsx ypo th morfh pinaka.
T = readmatrix("TMS.xlsx");
TMS=T(:,1); % TMS=1 se xrisi, TMS=0 xwris
SETUP=T(:,5); % exoume 6 setup
setup=T(TMS==0,5);
n=length(setup);

EDduration_noTMS = T(TMS==0,2); % Diarkeia ED xwris TMS.

% NOTES
% EDduration_noTMS: h ejarthmenh metavlhth.
% setup: h anejarthth metavlhth. Thelw na ejetasw ean ephreazei thn ejarthmenh.
% Exw ena montelo poy provlepei th metavlhth EDduration_noTMS me vash th metavlhth setup.

 %.................................................
 % ----------To montelo ths grammikhs palindromhshs einai:   --------------
 model = fitlm(EDduration_noTMS, setup);  %Y(X) --> Y=EDduration,  X=Setup

setupregM=[ones(length(setup),1) setup]; % M: matrix.
[bV, bint,r,rint,stats] = regress(EDduration_noTMS,setupregM);
% Parakato kanoume mia mikri epexigisi twn apotelesmatwn tis regress
% synartisis.
% bV --> oi parametroi tis grammikis palinrdomhshs
% bint --> to diastima empistosynhs autwn
% r --> residuals (ta ypoloipa) to sfalma grammikis palindomisis
% r --> diasthma empistosinis sfalmatwn
% stats --> 1.R^2  2.F-statistic 3.p-value 4.Residual variance (Se^2)
EDduration_noTMShat = setupregM * bV;
Sy2=1/(n-1)*sum((EDduration_noTMS-mean(EDduration_noTMS)).^2);
Sx2=1/(n-1)*sum((setup-mean(setup)).^2);
Se2=(n-1)/(n-2)*(Sy2-bV(2)^2*Sx2);
alpha=0.05;
t=tinv(1-alpha/2,n-2);    % opou  t(1-a/2,n-2)
% Elegxoume to diast. empist. tou b1
sxx=sum((setup-mean(setup)).^2);
Sb1=sqrt(Se2/sxx);
cib1=[bV(2)-t*Sb1 bV(2)+t*Sb1];

% Elegxoume to diast. empist. tou b0
Sb0=sqrt(Se2*((1/n) + (mean(setup)^2)/sxx));
cib0=[bV(1)-t*Sb0 bV(1)+t*Sb0];

% Ypologizoume to sfalma
e=EDduration_noTMS-EDduration_noTMShat;

% Elegxoume thn ypothesi oti Y den ejartate apothn X Ho: b1=0
t_stat=bV(2)/Sb1;
hb1=t_stat>t;
pb1=2*(1-tcdf(abs(t_stat),n-2)); % Mporoume na to paroume ap eutheias apo to stats(3) tis regress
% To apotelesma to Ho:hb1=1 , afou to t_stat<t_critical kai 
% h p-value einai pb1=0.3723>0.05 epomenws mporoyme na apodextoume
% thn mideniki ypothesi kai na poume oti h Y den exartate apo thn X.





% Dhmiourgoume ena diagramma diasporas kai grammikis palindromisis
x=linspace(min(setup)-1,max(setup)+1);
y=bV(1)+bV(2)*x;

figure(1);
plot(setupregM,EDduration_noTMS,'o');
hold on
line(x,y,'Color','black','LineWidth',2);
xlabel('Setup');
ylabel('ED no TMS duration');
title('Diagramma diasporas kai grammikis palindromisis');


% Ypologizoume ta sfalmata (e*) gia na dhmiourgisoume diagnostiko grafima
estar=e/sqrt(Se2);
zcrit = norminv(1-alpha/2);

% Dimiourgia Diagnostikou Grafimatos
figure(2);
plot(EDduration_noTMS,estar,'o');
hold on
ax = axis;
plot([ax(1) ax(2)],zcrit*[1 1],'c--')  % Dhmiourgia 2 oriakwn grammwn
plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
xlabel('percentage usable')
ylabel('residuals of linear regression')

% Briskoume to pososto twn sfalmatwn ektow oriwn (+/-)1.96
perc_estar=(sum(estar<(-zcrit))+sum(estar>zcrit))/length(estar);

% NOTES
% To pososto twn sfalmatwn tha prepei  na einai mikrotero apo 5%
% Sthn perptwsh maw einai 4.44%
% Sto diagramma parathroyme oti ta ypoloipa exoyn mia avxousa poreis.
% Ayto shmainei oti to montelo mas den einai katallhlo kai ta ypoloipa den
% einai asysxetista. Mallon yparxei epipleon anexartiti metavliti


% Ypologismos R^2 kai  adjR^2 kai emfanish aytwn sto diagramma diasporas
muEDduration_noTMS=mean(EDduration_noTMS);
Syyhat2=sum((EDduration_noTMS-EDduration_noTMShat).^2);
Syymu2=sum((EDduration_noTMS-muEDduration_noTMS).^2);
R2=1-(Syyhat2/Syymu2);
adjR2=1-(n-1)/(n-2)*(Syyhat2/Syymu2);
residuals = r; % Ta ypoloipa. (mporoume na to xrhsimopoihsoyme ap'eytheias apo tin 'regress'
% Emfanise ta apotelesmata sto 1o diagramma
figure(1)
ax = axis;
text(ax(1)+0.3*(ax(2)-ax(1)),ax(3)+0.2*(ax(4)-ax(3)),['R^2=',...
    num2str(R2,3)])
text(ax(1)+0.3*(ax(2)-ax(1)),ax(3)+0.1*(ax(4)-ax(3)),['adjR^2=',...
    num2str(adjR2,3)])

% Dhmioyrgia Istogrammatos - Elegxos katanomis sfalmatwn
pd = fitdist(r, 'Normal');

% Aytes oi 2 grammes kodika an thelo na emfaniso idanika kanonikh katanomh
% x = linspace(min(r)-20, max(r));  
% y = pdf(pd, x);

%gia ypologismo pyknothta piuanothtas apo deigma
[y, x] = ksdensity(r);

figure(3)
histogram(r,"Normalization","pdf");
hold on
plot(x,y,'Color','blue','LineWidth',2);
ylabel('frequency');
xlabel('Residuals bins');
title('Histogramm Residuals')
hold off

% Kano Elegxo kalhs prosarmoghs se kanonikh katanomh (an proerxontai ta
% sfalmata apo Normal Distribution).
% pd = fitdist(r, 'Normal');
h = chi2gof(r, 'CDF', pd);

% NOTES
% Gia na pw oti to montelo einai katallhlo, prepei ta ypoloipa (sfalmata) na
% akolouthoun mia kanonikh katanomi pragma pou apotynxanei kathos ston
% parapano elegxo kalhs prosarmogis h mhdenikh ypothesh oti proerxontai apo
% kanonikh katanomh aporiptetai.
% Symperasma mporoume na vgaloume parathrontas to diagramma.
% Akoma, oi syntelestes prosdiorismou exoun sxedon mhdenikes times
% R^2=0.060  kai adjR^2=-0.0015 .

% Tha xreiastoume perisoteres anejarthtes metavlites gia na mporesei na
% ektimhthei kalitera to montelo palindromhshs.


