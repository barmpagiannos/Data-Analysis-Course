% Group9Exe5Prog2
% Demitsoglou Panagiwths 
% Barmpagiannos Vasileios
clc, clearvars ,close all;

% Fortwnw to arxeio TMS.xlsx ypo th morfh pinaka.
T = readmatrix("TMS.xlsx");
TMS=T(:,1); % TMS=1 se xrisi, TMS=0 xwris
SETUP=T(:,5); % exoume 6 setup
setup=T(TMS==1,5);
n=length(setup);

EDduration_TMS = T(TMS==1,2); % Diarkeia ED xwris TMS.

% NOTES
% EDduration_TMS: h ejarthmenh metavlhth.
% setup: h anejarthth metavlhth. Thelw na ejetasw ean ephreazei thn ejarthmenh.
% Exw ena montelo poy provlepei th metavlhth EDduration_noTMS me vash th metavlhth setup.



setupregM=[ones(length(setup),1) setup];
[bV, bint,r,rint,stats] = regress(EDduration_TMS,setupregM);

EDduration_noTMShat = setupregM * bV;
Sy2=1/(n-1)*sum((EDduration_TMS-mean(EDduration_TMS)).^2);
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
e=EDduration_TMS-EDduration_noTMShat;

% Elegxoume thn ypothesi oti Y den ejartate apothn X Ho: b1=0
t_stat=bV(2)/Sb1;
hb1=t_stat<t;
pb1=2*(1-tcdf(abs(t_stat),n-2)); % Mporoume na to paroume ap eutheias apo to stats(3) tis regress
% To apotelesma to Ho:hb1=1 , afou to t_stat<t_critical kai 
% h p-value einai pb1=0.3723>0.05 epomenws mporoyme na aporipsoyme 
% thn ypothesi oti einai asysxetista.


% Dhmiourgoume ena diagramma diasporas kai grammikis palindromisis
x=linspace(min(setup)-1,max(setup)+1);
y=bV(1)+bV(2)*x;

figure(1);
plot(setupregM,EDduration_TMS,'o');
hold on
line(x,y,'Color','black','LineWidth',2);
xlabel('Setup');
ylabel('ED no TMS duration');
title('Diagramma diasporas kai grammikis palindromisis');

% Ypologizoume ta sfalmata (e*) gia na dhmiourgisoume diagnostiko grafima
estar=e/sqrt(Se2);
zcrit = norminv(1-alpha/2); %ypologizoume thn critical timi z=~(+/-)1.96

% Dimiourgia Diagnostikou Grafimatos
figure(2);
plot(EDduration_TMS,estar,'o');
hold on
ax = axis;
plot([ax(1) ax(2)],zcrit*[1 1],'c--')
plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
xlabel('percentage usable')
ylabel('residuals of linear regression')

% Ypologismos posostou sfalmatwn ektos oriwn
perc_estar=(sum(estar<(-zcrit))+sum(estar>zcrit))/length(estar);

% NOTES
% To pososto twn sfalmatwn tha prepei  na einai mikrotero apo 5%
% Sthn perptwsh mas einai 3.36% ,apodekto.
% Sto diagramma parathroyme oti ta ypoloipa exoyn mia avxousa poreis.
% Ayto shmainei oti to montelo mas den einai katallhlo kai ta ypoloipa den
% einai asysxetista. Mallon yparxei epipleon anexartiti metavliti



% Ypologismos R^2 kai  adjR^2
muEDduration_noTMS=mean(EDduration_TMS);
Syyhat2=sum((EDduration_TMS-EDduration_noTMShat).^2);
Syymu2=sum((EDduration_TMS-muEDduration_noTMS).^2);

R2=1-(Syyhat2/Syymu2);
adjR2=1-(n-1)/(n-2)*(Syyhat2/Syymu2);
residuals = r; % Ta ypoloipa.

% Dhmioyrgia Istogrammatos - Elegxos katanomis sfalmatwn
pd = fitdist(r, 'Normal');
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
%pd = fitdist(r, 'Normal');
h = chi2gof(r, 'CDF', pd);

% Gia na pw oti to montelo einai katallhlo, prepei ta ypoloipa (sfalmata) na
% akolouthoun mia kanonikh katanomi pragma pou apotynxanei kathos ston
% parapano elegxo kalhs prosarmogis h mhdenikh ypothesh oti proerxontai apo
% kanonikh katanomh aporiptetai.
% Akoma, oi syntelestes prosdiorismou exoun sxedon mhdenikes times
% R^2=0.084  kai adjR^2=0.0762.


