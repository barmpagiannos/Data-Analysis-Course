% Demitsoglou Panagiwths
% Barmpagiannos Vasileios
clc, clear;

% Fortwnw to arxeio TMS.xlsx ypo th morfh pinaka.
T = readmatrix("TMS.xlsx");
EDduration_TMS = T(1:119,2); % Diarkeia ED me TMS.
EDduration_noTMS = T(120:254,2); % Diarkeia ED xwris TMS.

%% Ftiaxnw ta istogrammata twn duo EDduration.
figure
histogram(EDduration_TMS, 'Normalization','pdf', 'FaceColor','r')
legend("TMS")
figure
histogram(EDduration_noTMS, 'Normalization','pdf', 'FaceColor','b')
legend("noTMS")

%% Apo ta parapanw duo istogrammata parathrw oti h katanomh pou einai h pio
% katallhlh gia tis diarkeies EDduration, me kai xwris TMS, einai h
% ekthetikh. Tha ektelesw elegxo kalhs prosarmoghs gia na to epivevaiwsw.
pd1 = fitdist(EDduration_TMS, 'Exponential');
h1 = chi2gof(EDduration_TMS, 'CDF', pd1);
pd2 = fitdist(EDduration_noTMS, 'Exponential');
h2 = chi2gof(EDduration_noTMS, 'CDF', pd2);

if h1 == 0
    sprintf("h1 = %d so the data on EDduration_TMS come from an exponential distribution.", h1)
else
    sprintf("h1 = %d so the data on EDduration_TMS don't come from an exponential distribution.", h1)
end
if h2 == 0
    sprintf("h2 = %d so the data on EDduration_noTMS come from an exponential distribution.", h2)
else
    sprintf("h2 = %d so the data on EDduration_noTMS don't come from an exponential distribution.", h2)
end

% Pragmati h ekthetikh einai h katallhloterh katanomh.

%% Edw tha sxediasw thn kampulh ths ekthetikhs katanomhs gia tis duo diarkeies.
x1 = 1:119;
y1 = pdf(pd1, x1); % EDduration_TMS
x2 = 1:135;
y2 = pdf(pd2, x2); % EDduration_noTMS

figure
plot(x1, y1, 'r');
hold on
plot(x2, y2, 'b');
legend("TMS", "noTMS");

% Apo tis duo katanomes, parathrw oti h spp gia th diarkeia ED einai
% idia me h xwris TMS.
