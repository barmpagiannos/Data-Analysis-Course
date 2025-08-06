% Demitsoglou Panagiwths
% Barmpagiannos Vasileios
clc, clearvars ,close all;

% Fortwnw to arxeio TMS.xlsx ypo th morfh pinaka.
T = readmatrix("TMS.xlsx");
TMS=T(:,1); % TMS=1 se xrisi, TMS=0 xwris
SETUP=T(:,5); % exoume 6 setup
% EDduration_TMS = T(TMS==1,2); % Diarkeia ED me TMS.  ----> DEN TO XRHSIMOPOIOUME KAPOU

% Oi diarkeies preTMS kai postTMS gia kathe mia apo tis 6 katastaseis metrhshs.
EDduration_preTMS_1 = T(TMS==1 & SETUP==1 ,3); % Diarkeia preTMS me setup=1.
EDduration_postTMS_1 = T(TMS==1 & SETUP==1 ,4); % Diarkeia preTMS me setup=1.
r1 = corr(EDduration_preTMS_1, EDduration_postTMS_1); % Deigmatikos syntelesths sysxetishs.

EDduration_preTMS_2 = T(TMS==1 & SETUP==2 ,3); % Diarkeia preTMS me setup=2.
EDduration_postTMS_2 = T(TMS==1 & SETUP==2 ,4); % Diarkeia preTMS me setup=2.
r2 = corr(EDduration_preTMS_2, EDduration_postTMS_2);

EDduration_preTMS_3 = T(TMS==1 & SETUP==3 ,3); % Diarkeia preTMS me setup=3.
EDduration_postTMS_3 = T(TMS==1 & SETUP==3 ,4); % Diarkeia preTMS me setup=3.
r3 = corr(EDduration_preTMS_3, EDduration_postTMS_3);

EDduration_preTMS_4 = T(TMS==1 & SETUP==4 ,3); % Diarkeia preTMS me setup=4.
EDduration_postTMS_4 = T(TMS==1 & SETUP==4 ,4); % Diarkeia preTMS me setup=4.
r4 = corr(EDduration_preTMS_4, EDduration_postTMS_4);

EDduration_preTMS_5 = T(TMS==1 & SETUP==5 ,3); % Diarkeia preTMS me setup=5.
EDduration_postTMS_5 = T(TMS==1 & SETUP==5 ,4); % Diarkeia preTMS me setup=5.
r5 = corr(EDduration_preTMS_5, EDduration_postTMS_5);

EDduration_preTMS_6 = T(TMS==1 & SETUP==6 ,3); % Diarkeia preTMS me setup=6.
EDduration_postTMS_6 = T(TMS==1 & SETUP==6 ,4); % Diarkeia preTMS me setup=6.
r6 = corr(EDduration_preTMS_6, EDduration_postTMS_6);

fprintf('Setup1 \t Setup2 \t Setup3 \t Setup4 \t Setup5 \t Setup6\n');
fprintf('r1=%.2f \t r2=%.2f \t r3=%.2f \t r4=%.2f \t r5=%.2f \t r6=%.2f \n',100*r1^2,100*r2^2,100*r3^2,100*r4^2,100*r5^2,100*r6^2);

%% Twra tha ektelesw parametriko elegxo mhdenikhs sysxetishs.
% Mhdenikh ypothesi Ho: r=0.

n1 = length(EDduration_preTMS_1);
n2 = length(EDduration_preTMS_2);
n3 = length(EDduration_preTMS_3);
n4 = length(EDduration_preTMS_4);
n5 = length(EDduration_preTMS_5);
n6 = length(EDduration_preTMS_6);
n = [n1,n2,n3,n4,n5,n6]; % Oloi vathmoi eleftherias mazemenoi.
r = [r1,r2,r3,r4,r5,r6]; % Oloi oi deigmatikoi syntelestes sysxetishs mazemenoi.
t = zeros(6, 1); % Oi times twn statistikwn t mazemenes gia kathena apo ta 6 deigmata.
p_val = zeros(6,1); % Oi p-times twn elegxwn mazemenes.

for i=1:6
    t(i) = r(i)*sqrt((n(i)-2)/(1-r(i)^2));
    p_val(i) = 2*(1 - tcdf(abs(t(i)), n(i)-2));
end

fprintf('p1=%.4f \t p2=%.4f \t p3=%.4f \t p4=%.4f \t p5=%.4f \t p6=%.4f \n', ...
         p_val(1),p_val(2),p_val(3),p_val(4),p_val(5),p_val(6));

% Oles oi p-times einai poly megalyteres toy mhdenos ara yparxei shmantikh
% pithanothta na isxyei h mhdenikh ypothesh, ara kai gia ta 6 deigmata, oi
% xronoi preTMS kai postTMS einai ASYSXETISTOI.

%% Twra tha ektelesw elegxo tyxaiopoihshs me 1000 tyxaiopoihmena deigmata.
% p = randperm(n)
% returns a row vector containing a random permutation of the integers 
% from 1 to n without repeating elements.

% Allazw th seira twn parathrhsewn ths mias apo tis duo t.m. kai sygkekrimena ths preTMS.
% Theloume L = 1000 tyxaiopoihmena deigmata.
L = 1000;
deigmata1 = zeros(L, length(EDduration_preTMS_1)); % Ta 1000 deigmata ths preTMS_1.
deigmata2 = zeros(L, length(EDduration_preTMS_2)); % Ta 1000 deigmata ths preTMS_2.
deigmata3 = zeros(L, length(EDduration_preTMS_3)); % Ta 1000 deigmata ths preTMS_3.
deigmata4 = zeros(L, length(EDduration_preTMS_4)); % Ta 1000 deigmata ths preTMS_4.
deigmata5 = zeros(L, length(EDduration_preTMS_5)); % Ta 1000 deigmata ths preTMS_5.
deigmata6 = zeros(L, length(EDduration_preTMS_6)); % Ta 1000 deigmata ths preTMS_6.

for i=1:L
    index = randperm(length(EDduration_preTMS_1)); % Dianysma tyxaiwn deiktwn.
    deigmata1(i, :) = EDduration_preTMS_1(index'); % Tyxaiopoihmena deigmata gia to preTMS.
    index = randperm(length(EDduration_preTMS_2));
    deigmata2(i, :) = EDduration_preTMS_2(index');
    index = randperm(length(EDduration_preTMS_3));
    deigmata3(i, :) = EDduration_preTMS_3(index');
    index = randperm(length(EDduration_preTMS_4));
    deigmata4(i, :) = EDduration_preTMS_4(index');
    index = randperm(length(EDduration_preTMS_5));
    deigmata5(i, :) = EDduration_preTMS_5(index');
    index = randperm(length(EDduration_preTMS_6));
    deigmata6(i, :) = EDduration_preTMS_6(index');
end

% Ta statistika t gia kathena apo ta arxika deigmata preTMS ta ypologisame
% prin kai vriskontai sto dianysma t.
% Twra tha ypologisw ta statistika t gia kathena apo ta L = 1000
% tyxaiopoihmena deigmata, gia kathe preTMS.

% Ta t statistika gia kathena apo ta 1000 tyxaiopoihmena deigmata ths preTMS.
% Arxikopoihsh sxrikwn pinakwn
t_deigmata1 = zeros(L, 1);
t_deigmata2 = zeros(L, 1);
t_deigmata3 = zeros(L, 1);
t_deigmata4 = zeros(L, 1);
t_deigmata5 = zeros(L, 1);
t_deigmata6 = zeros(L, 1);

% Oi syntelestes sysxetishs gia kathena apo ta 1000 tyxaiopoihmena deigmata ths preTMS.
% Arxikopoihsh sxrikwn pinakwn
r_deigmata1 = zeros(L, 1);
r_deigmata2 = zeros(L, 1);
r_deigmata3 = zeros(L, 1);
r_deigmata4 = zeros(L, 1);
r_deigmata5 = zeros(L, 1);
r_deigmata6 = zeros(L, 1);

for i=1:L
    r_deigmata1(i) = corr(deigmata1(i, :)', EDduration_postTMS_1);
    t_deigmata1(i) = r_deigmata1(i)*sqrt((length(deigmata1(i, :))-2)/(1-r_deigmata1(i)^2));
    r_deigmata2(i) = corr(deigmata2(i, :)', EDduration_postTMS_2);
    t_deigmata2(i) = r_deigmata2(i)*sqrt((length(deigmata2(i, :))-2)/(1-r_deigmata2(i)^2));
    r_deigmata3(i) = corr(deigmata3(i, :)', EDduration_postTMS_3);
    t_deigmata3(i) = r_deigmata3(i)*sqrt((length(deigmata3(i, :))-2)/(1-r_deigmata3(i)^2));
    r_deigmata4(i) = corr(deigmata4(i, :)', EDduration_postTMS_4);
    t_deigmata4(i) = r_deigmata4(i)*sqrt((length(deigmata4(i, :))-2)/(1-r_deigmata4(i)^2));
    r_deigmata5(i) = corr(deigmata5(i, :)', EDduration_postTMS_5);
    t_deigmata5(i) = r_deigmata5(i)*sqrt((length(deigmata5(i, :))-2)/(1-r_deigmata5(i)^2));
    r_deigmata6(i) = corr(deigmata6(i, :)', EDduration_postTMS_6);
    t_deigmata6(i) = r_deigmata6(i)*sqrt((length(deigmata6(i, :))-2)/(1-r_deigmata6(i)^2));
end

% H mhdenikh ypothesh aporriptetai an h timh t0 den periexetai sthn katanomh twn t1,t2,...,tL.
alpha = 0.05; % Epipedo shmantikothtas.

sort_t_deigmata1 = sort(t_deigmata1); % Fairnw ta statistika t se ayjoysa seira.
sort_t_deigmata2 = sort(t_deigmata2); % Fairnw ta statistika t se ayjoysa seira.
sort_t_deigmata3 = sort(t_deigmata3); % Fairnw ta statistika t se ayjoysa seira.
sort_t_deigmata4 = sort(t_deigmata4); % Fairnw ta statistika t se ayjoysa seira.
sort_t_deigmata5 = sort(t_deigmata5); % Fairnw ta statistika t se ayjoysa seira.
sort_t_deigmata6 = sort(t_deigmata6); % Fairnw ta statistika t se ayjoysa seira.

apotelesma1 = all(t(1) > (sort_t_deigmata1(L*alpha/2))) && all(t(1) < sort_t_deigmata1(L*(1-alpha/2)));
% To apotelesma einai 1 (alithes).

apotelesma2 = all(t(2) > (sort_t_deigmata2(L*alpha/2))) && all(t(2) < sort_t_deigmata2(L*(1-alpha/2)));
% To apotelesma einai 1 (alithes).

apotelesma3 = all(t(3) > (sort_t_deigmata3(L*alpha/2))) && all(t(3) < sort_t_deigmata3(L*(1-alpha/2)));
% To apotelesma einai 1 (alithes).

apotelesma4 = all(t(4) > (sort_t_deigmata4(L*alpha/2))) && all(t(4) < sort_t_deigmata4(L*(1-alpha/2)));
% To apotelesma einai 1 (alithes).

apotelesma5 = all(t(5) > (sort_t_deigmata5(L*alpha/2))) && all(t(5) < sort_t_deigmata5(L*(1-alpha/2)));
% To apotelesma einai 1 (alithes).

apotelesma6 = all(t(6) > (sort_t_deigmata6(L*alpha/2))) && all(t(6) < sort_t_deigmata6(L*(1-alpha/2)));
% To apotelesma einai 1 (alithes).

% Gia kathe deigma, to kathe statistiko t0 tou kathe deigmatos periexetai
% anamesa sta La/2 kai L(1-a/2) posostiaia shmeia, ara den aporriptetai h
% mhdenikh ypothesi kai ta deigmata einai ASYSXETISTA.

% O pinakas me ta apotelesmata. Einai alhthoi, ara ta deigmata einai
% asysxetista.
apotelesmata = [apotelesma1, apotelesma2, apotelesma3, apotelesma4, apotelesma5, apotelesma6];

% Me vash ton parametriko elegxo kai ton elegxo tyxaiopoihshs den fainetai
% na yparxei kamia sysxetish metajy twn preTMS kai postTMS xronwn kai gia
% kamia katastash metrhshs.

% Kaname parametriko elegxo theorwntas oti to statistiko t akoloythei
% katanomh Student kai to ypologisame me vash th sxesh (5.5) twn shmeiwsewn
% toy mathimatos.
% O elegxos tyxaiopoihshs ginetai xwris na theorhsw gnwsth katanomh toy
% statistikoy t gia ayto einai pio genikos kai ajiopistos.
% Ara gia oles tis katastaseis metrhshs empisteyomai perissotero ton elegxo
% tyxaiopoihshs.

