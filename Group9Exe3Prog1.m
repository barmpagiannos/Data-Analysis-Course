% Demitsoglou Panagiwths
% Barmpagiannos Vasileios
clc, clearvars,close all;

% Fortwnw to arxeio TSM.xlsx ypo ths morfh pinaka.
T = readmatrix("TMS.xlsx");
TMS=T(:,1); % TMS=1 se xrisi, TMS=0 xwris
SETUP_noTMS=T(TMS==0,5); % exoume 6 setup
EDduration_noTMS = T(TMS==0,2); % Diarkeia ED XWRIS TMS.
m0 = mean(EDduration_noTMS); % mesh timh diarkeias ED xwris TMS.

% 6 deigmata gia kathe mia apo tis 6 katastaseis metrhshs.
EDduration_noTMS_1 = EDduration_noTMS(SETUP_noTMS==1); % Diarkeia ED xwris TMS me setup=1.
EDduration_noTMS_2 = EDduration_noTMS(SETUP_noTMS==2); % Diarkeia ED xwris TMS me setup=2.
EDduration_noTMS_3 = EDduration_noTMS(SETUP_noTMS==3); % Diarkeia ED xwris TMS me setup=3.
EDduration_noTMS_4 = EDduration_noTMS(SETUP_noTMS==4); % Diarkeia ED xwris TMS me setup=4.
EDduration_noTMS_5 = EDduration_noTMS(SETUP_noTMS==5); % Diarkeia ED xwris TMS me setup=5.
EDduration_noTMS_6 = EDduration_noTMS(SETUP_noTMS==6); % Diarkeia ED xwris TMS me setup=6.

% Ektelw 6 elegxoys ypothesis gia ta parapanw deigmata.
% Thelw na dw ean h katanomh mporei na thewrhthei kanonikh.
h1nT = chi2gof(EDduration_noTMS_1);
h2nT = chi2gof(EDduration_noTMS_2);
h3nT = chi2gof(EDduration_noTMS_3);
h4nT = chi2gof(EDduration_noTMS_4);
h5nT = chi2gof(EDduration_noTMS_5);
h6nT = chi2gof(EDduration_noTMS_6);

% h1,h3,h5,h6 = 0 ara oi antistoixes katanomes mporoun na theorhthoyn
% kanonikes. Elegxw twra ean mporei na theorhthoyn kanonikes me mesh timh
% m0.
h11nT = ttest(EDduration_noTMS_1, m0);
h33nT = ttest(EDduration_noTMS_3, m0);
h55nT = ttest(EDduration_noTMS_5, m0);
[h66nT, ~, ~, ~] = ttest(EDduration_noTMS_6, m0);  % ENALLAKTIKOS TROPOS

% Kai parathrw oti oi katanomes twn EDduration_noTMS_3 kai
% EDduration_noTMS_5 den mporei na theowrhthei oti exoyn mesh diarkeia m0,
% afoy h33,h55 = 1. Oi katanomes twn EDduration_noTMS_1 kai
% EDduration_noTMS_6 mporoyn na theorhthoyn kanonikes me mesh
% diarkeia m0, afoy h11,h66 = 0.

% Parathrw oti h2 kai h4 =1 ara oi katanomes twn EDduration_noTMS_2 kai EDduration_noTMS_2
% den mporoyn na theorhthoyn kanonikes. Se auth thn periptwsh, efarmozw bootstrap diasthma empistosynhs.
% Xrhsimopoiw 2000 bootstrap samples.
ci2nT = bootci(2000, @mean, EDduration_noTMS_2);
ci4nT = bootci(2000, @mean, EDduration_noTMS_4);

% -----  Diadikasia gia elegxo ypothesis
H0_2 = m0;
bootstrapMeans = bootstrp(2000, @mean, EDduration_noTMS_2);
pValue = mean(abs(bootstrapMeans) >= abs(H0_2));
% Elegxos ypothesis
alpha = 0.05; % Simantikothta
h22nT= pValue < alpha;

H0_4 = m0;
bootstrapMeans = bootstrp(2000, @mean, EDduration_noTMS_4);
pValue = mean(abs(bootstrapMeans) >= abs(H0_4));
% Elegxos ypothesis
alpha = 0.05; % Simantikothta
h44nT = pValue < alpha;

% Parathrw oti h mesh timh m0 anhkei sto diasthma empistosynhs ci2 enw den
% anhkei sto ci4. Ara h katanomh toy EDduration_noTMS_2 mporei na
% thewrhthei oti exei mesh timh m0 enw ayth toy EDduration_noTMS_4 oxi.


%---------------------------------------------------------------------
% Me TMS deigmata
SETUP_TMS=T(TMS==1,5); % exoume 6 setup
EDduration_TMS = T(TMS==1,2); % Diarkeia ED XWRIS TMS.

m0 = mean(EDduration_TMS); % mesh timh diarkeias ED me TMS.

% 6 deigmata gia kathe mia apo tis 6 katastaseis metrhshs.
EDduration_TMS_1 = EDduration_TMS(SETUP_TMS==1); % Diarkeia ED me TMS me setup=1.
EDduration_TMS_2 = EDduration_TMS(SETUP_TMS==2); % Diarkeia ED me TMS me setup=2.
EDduration_TMS_3 = EDduration_TMS(SETUP_TMS==3); % Diarkeia ED me TMS me setup=3.
EDduration_TMS_4 = EDduration_TMS(SETUP_TMS==4); % Diarkeia ED me TMS me setup=4.
EDduration_TMS_5 = EDduration_TMS(SETUP_TMS==5); % Diarkeia ED me TMS me setup=5.
EDduration_TMS_6 = EDduration_TMS(SETUP_TMS==6); % Diarkeia ED me TMS me setup=6.

% Ektelw 6 elegxoys ypothesis gia ta parapanw deigmata.
% Thelw na dw ean h katanomh mporei na thewrhthei kanonikh.
h1T = chi2gof(EDduration_TMS_1);
h2T = chi2gof(EDduration_TMS_2);
h3T = chi2gof(EDduration_TMS_3);
h4T = chi2gof(EDduration_TMS_4);
h5T = chi2gof(EDduration_TMS_5);
h6T = chi2gof(EDduration_TMS_6);

% h1,h3,h5,h6 = 0 ara oi antistoixes katanomes mporoun na theorhthoyn
% kanonikes. Elegxw twra ean mporei na theorhthoyn kanonikes me mesh timh
% m0.
[h11T, ~, ci1, ~] = ttest(EDduration_TMS_1, m0);
h33T = ttest(EDduration_TMS_3, m0);
h55T = ttest(EDduration_TMS_5, m0);
h66T = ttest(EDduration_TMS_6, m0);

% Kai parathrw oti h katanomh tou EDduration_TMS_6 den mporei na theowrhthei 
% oti exei mesh diarkeia m0 afoy h66 = 1. Oi katanomes twn EDduration_TMS_1,
% EDduration_TMS_3 kai EDduration_TMS_5 mporoyn na theorhthoyn kanonikes me mesh
% diarkeia m0, afoy h11,h33,h55 = 0. 

% Parathrw oti h2 kai h4 =1 ara oi katanomes twn EDduration_TMS_2 kai EDduration_TMS_2
% den mporoyn na theorhthoyn kanonikes. Se auth thn periptwsh, efarmozw bootstrap diasthma empistosynhs.
% Xrhsimopoiw 2000 bootstrap samples.
ci2 = bootci(2000, @mean, EDduration_TMS_2);
ci4 = bootci(2000, @mean, EDduration_TMS_4);

% -----  Diadikasia gia elegxo ypothesis
H0_2 = m0;
bootstrapMeans = bootstrp(2000, @mean, EDduration_TMS_2);
pValue = mean(abs(bootstrapMeans) >= abs(H0_2));
% Elegxos ypothesis
alpha = 0.05; % Simantikothta
h22T= pValue < alpha;

H0_4 = m0;
bootstrapMeans = bootstrp(2000, @mean, EDduration_TMS_4);
pValue = mean(abs(bootstrapMeans) >= abs(H0_4));
% Elegxos ypothesis
alpha = 0.05; % Simantikothta
h44T = pValue < alpha;

% Parathrw oti h mesh timh m0 den anhkei sta diasthmata empistosynhs ci2 kai ci4.
% Ara oi katanomes twn EDduration_TMS_2 kai EDduration_TMS_4 den mporei na thewrhthei 
% oti exei mesh timh m0.


% Dimiourgeia Pinaka me ola ta stoixeia

SETUPnum=['Setup1';'Setup2';'Setup3';'Setup4';'Setup5';'Setup6'];
UniformDistr_nTMS=[h1nT;h2nT;h3nT;h4nT;h5nT;h6nT];
t_test_param_nTMS=[h11nT;NaN;h33nT;NaN;h55nT;h66nT];
test_btstrp_nTMS=[NaN;h22nT;NaN;h44nT;NaN;NaN];
UniformDistr_TMS=[h1T;h2T;h3T;h4T;h5T;h6T];
t_test_param_TMS=[h11T;NaN;h33T;NaN;h55T;h66T];
test_btstrp_TMS=[NaN;h22T;NaN;h44T;NaN;NaN];

ResultsTable = table(SETUPnum, UniformDistr_nTMS, t_test_param_nTMS, test_btstrp_nTMS, ...
                               UniformDistr_TMS,t_test_param_TMS,test_btstrp_TMS);

% Εμφάνιση πίνακα
disp('HYPOTHESIS TEST TABLE RESULT:');
disp(ResultsTable);


