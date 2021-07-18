%% Personal details
%Name : Nischith Shadagopan M N
%Roll number : CS18B102
%% Q1
%I would expect 1000 spikes in this spike train.There is one spike every
%20ms and hence in 20s there would be 1000 spikes.

%% Q2
%sum(Spikes2);

%% Q3
% In this case MFR = FR = 1/(20*Dt)  
%MFR = 1/(20*Dt);

%% Q4
clear all
load('HW1Data_SpikeTrain.mat');
ISI = diff(ST);
figure;
[y, x] = hist(ISI, 50);plot(x, y)
xlabel('Time(ISI) in ms')
ylabel('Counts')
calSC = hist(ST, T_bc);
%My calculated SC differs only in the first time bin compared to given SC
[correlation,lags]=xcorr(calSC,'coeff');
figure;plot(lags,correlation)
xlabel('lag')
ylabel('Auto correlation')
%time_bin is the difference of consecutive values in T_bc
time_bin = T_bc(2)-T_bc(1);
%Duration of recording in seconds = time_bin * size(T_bc)
RecTime = time_bin * size(T_bc, 2); %in seconds
%To calculate resolution
Resolution = median(diff(T_bc)); %in seconds

%% Q5
T=5;
Dt=1e-3; 
Timepoints=T/Dt;
Spikes1=zeros(T/Dt,1);
Spikes1(1:500:Timepoints) = 1;
Spikes2=zeros(T/Dt,1);
Spikes2(1:700:Timepoints) = 1;
%I would expect to see the autocorrelation of these spike trains to be 
%bounded by a triangle due to finite data effect. Also I expect the value
%of autocorrelation to be non zero at multiples of 500 for the first 
%spike train and multiples of 700 for the second spike train along with 0.
%this is due to periodicity of 500 and 700 respectively.
[correlation,lags]=xcorr(Spikes1,'coeff');
figure;plot(lags, correlation)
title('Auto correlation of Spikes1')
xlabel('lag')
ylabel('Auto correlation')
[correlation,lags]=xcorr(Spikes2,'coeff');
figure;plot(lags, correlation)
title('Auto correlation of Spikes2')
xlabel('lag')
ylabel('Auto correlation')
[correlation,lags]=xcorr(Spikes1, Spikes2,'coeff');
figure;plot(lags, correlation) %figure x
title('Cross correlation of Spikes1 with Spikes2')
xlabel('lag')
ylabel('Auto correlation')
[correlation,lags]=xcorr(Spikes2, Spikes1,'coeff');
figure;plot(lags, correlation) %figure y
title('Cross correlation of Spikes2 with Spikes1')
xlabel('lag')
ylabel('Auto correlation')
%The crosscorrelation plot is also bounded by a triangle due to finite
%data effect. Also figure x and figure y are mirror images of each other as
%a positive lag on Spikes1 is equivalent to a negative lag on Spikes2 with
%respect to crosscorrelation. While all this was expected, the lag 
%corresponding to non zero value in the graph was hard to predict and hence
%was unexpected. Mathematically the lags corresponding to non zero value
%must satisfy 500*x = 700*y + lag for some integer values of x and y. From 
%this condition we get that lags giving rise to non zero value must be a 
%multiple of HCF(500, 700) = 100 (basic number theory).




