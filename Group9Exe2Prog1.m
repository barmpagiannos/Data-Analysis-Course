% Demitsoglou Panagiwths
% Barmpagiannos Vasileios
clc, clearvars,close all;

% Fortwnw to arxeio TSM.xlsx ypo ths morfh pinaka.
T = readmatrix("TMS.xlsx");
TMS=T(:,1); % TMS=1 se xrisi, TMS=0 xwris 
EDduration_TMS = T(TMS==1,2); % Diarkeia ED me TMS.
Coil_TMS=T(TMS==1,10); % Epilogi piniou 1-Octari  0-Strogilo

EDduration_TMS_8=EDduration_TMS(Coil_TMS==1); % Diarkeia ED me TMS kai phnio se sxhma oktari (8).
EDduration_TMS_0=EDduration_TMS(Coil_TMS==0); % Diarkeia ED me TMS kai phnio se sxhma stroggylo (0).


% DEN NOMIZO OTI XREIAZETAI KAPOY ----------
%%%  -------  lamda = 1/mean(EDduration_TMS); % Parametros katanomhs apo to arxiko deigma. 

lamda8 = 1/mean(EDduration_TMS_8); % Parametros katanomhs apo to EDduration_TMS_8.
lamda0 = 1/mean(EDduration_TMS_0); % Parametros katanomhs apo to EDduration_TMS_0.

resampled_TMS_8 = exprnd(lamda8, [1000, length(EDduration_TMS_8)]); % 1000 tyxaia deigmata me 19 parathrhseis ekasto.
resampled_TMS_0 = exprnd(lamda0, [1000, length(EDduration_TMS_0)]); % 1000 tyxaia deigmata me 100 parathrhseis ekasto.

% EDW vrisko gia kathe arxiko deigma to X^2 (xehorista opos zitaei gia octari kai strogylo)
pd = fitdist(EDduration_TMS_8, 'Exponential');
[~,~,stats] = chi2gof(EDduration_TMS_8, 'CDF', pd);
chi2stat_TMS8_ini = stats.chi2stat;
pd = fitdist(EDduration_TMS_0, 'Exponential');
[~,~,stats] = chi2gof(EDduration_TMS_8, 'CDF', pd);
chi2stat_TMS0_ini = stats.chi2stat;

% Kanoume Arxikopoisi pinakwn
chi2stat_TMS_8 = zeros(length(EDduration_TMS_8), 1); % Oi times twn statistikwn gia to deigma me phnio oktari.
chi2stat_TMS_0 = zeros(length(EDduration_TMS_0), 1); % Oi times twn statistikwn gia to deigma me phnio stroggylo.

for i=1:1000 % Gia tis 1000 grammes twn resampled deigmatwn ektelw elegxo kalhs prosarmoghs.
    pd8 = fitdist(resampled_TMS_8(i, :)', 'Exponential'); % Kathe grammi einai kai ena deigma.
    [~,~,stats8] = chi2gof(resampled_TMS_8(i, :), 'CDF', pd8);
    chi2stat_TMS_8(i) = stats8.chi2stat; % Apothykeysi toy statistikoy chi2.

    pd0 = fitdist(resampled_TMS_0(i, :)', 'Exponential');
    [~,~,stats0] = chi2gof(resampled_TMS_0(i, :), 'CDF', pd0);
    chi2stat_TMS_0(i) = stats0.chi2stat;
end

%% Kanoyme plot thn empeirikh katanomh mesw istogrammatwn kai me Kernel Density Estimation.
% Oi times toy statistikoy chi2 gia to deigma TMS me phnio oktari einai chi2stat_TMS_8.
% Oi times toy statistikoy chi2 gia to deigma TMS me phnio stroggylo einai chi2stat_TMS_0.
% H timh toy statistikoy chi2 gia to arxiko deigma TMS einai chi2stat_TMS_8.

% Dhmiourgeia plot gia Octari phnio
figure
histogram(chi2stat_TMS_8, 'Normalization', 'pdf', 'FaceColor','g');
hold on
[fi8,xi8] = ksdensity(chi2stat_TMS_8);
plot(xi8,fi8, 'LineWidth', 2, 'Color', 'r');
xline(chi2stat_TMS8_ini, 'LineWidth', 3,'Color','b');
legend("Phnio: sxhma strogylo", "pdf", "chi2stat");
title('Strogylo Phnio');
hold off

% Dhmiourgeia plot gia Strogylo phnio
figure
histogram(chi2stat_TMS_0, 'Normalization', 'pdf', 'FaceColor','b');
hold on;
[fi0,xi0] = ksdensity(chi2stat_TMS_0);
plot(xi0,fi0, 'LineWidth', 2, 'Color',"black");
xline(chi2stat_TMS8_ini, 'LineWidth', 2);
legend("Phnio: sxhma oktari", "pdf", "chi2stat");
title('Octari Phnio');
hold off;

%-----------------------------------------------------------------------
% % %% Kanoyme plot thn empeirikh katanomh me Kernel Density Estimation.
% % figure
% % [fi8,xi8] = ksdensity(chi2stat_TMS_8);
% % plot(xi8,fi8, 'LineWidth', 2, 'Color', 'r');
% % xline(chi2stat_TMS8_ini, 'LineWidth', 2,'Color','g');
% % hold on;
% % [fi0,xi0] = ksdensity(chi2stat_TMS_0);
% % plot(xi0,fi0, 'LineWidth', 2, 'Color', 'b');
% % xline(chi2stat_TMS8_ini, 'LineWidth', 2);
% % % legend("Phnio: sxhma oktari", "Phnio: sxhma stroggylo", "chi2stat");
% % hold off;
%-----------------------------------------------------------------------


% To chi2stat (dhladh to chi0^2) einai sth dejia oyra ths empeirikhs
% katanomhs gia to deigma TMS me phnio se sxhma stroggylo alla den
% symbainei to idio gia to deigma TMS me phnio se sxhma oktari.

% O elegxos katallhlothtas katanomhs gia ekthetikh katanomh me
% epanadeigmatolhpsia bgazei ta idia symperasmata me ton parametriko elegxo
% chi-square gia ekthetikh katanomh.

% Telos, ta apotelesmata twn dyo elegxwn diaferoyn sta dyo deigmata: phnio
% oktari kai phnio stroggylo. Sygkekrimena, oi times toy statistikoy
% chi2-square gia phnio se sxhma oktari den prosarmozontai kala sthn
% ektheikh katanomh.

%% Parametrikos elegxos.
pd8 = fitdist(chi2stat_TMS_8, 'Exponential');
[h8,p8,stat8] = chi2gof(chi2stat_TMS_8, 'CDF', pd8); % Phnio se sxhma oktari.
pd0 = fitdist(chi2stat_TMS_0, 'Exponential');
[h0,p0,stat0] = chi2gof(chi2stat_TMS_8, 'CDF', pd0); % Phnio se sxhma stroggylo.
fprintf('h8=%d \n',h8);
if h8==1, fprintf("Aporiptetai !\n\n"); else, fprintf("Apodexomaste !\n\n"); end
fprintf('h0=%d \n',h0);
if h0==1, fprintf("Aporiptetai !\n\n"); else, fprintf("Apodexomaste !\n\n"); end


% O parametrikos elegxos edeije h8 = 1, dhladh to sxhma oktari apetyxe ston 
% elegxo katallhlothtas gia ekthetikh katanomh.
% Epishs h0 = 0, dhladh to sxhma stroggylo petyxe ston elegxo katallhlothtas 
% gia ekthetikh katanomh.
