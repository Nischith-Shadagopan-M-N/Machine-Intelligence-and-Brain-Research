%% Personal details
%Name : Nischith Shadagopan M N
%Roll number : CS18B102
%% Q1
clear all
load('Data1D.mat');
load('Data2D.mat');
ses=1;
ID=1;
SpikeTimes=Data1D(ses).UIF(ID).ST;
Position=Data1D(ses).beh.Position;
TimeVector=Data1D(ses).beh.Time;
Dt=median(diff(TimeVector))/1e6;
SpikeIndices=nearestpoint(SpikeTimes,TimeVector);
ThetaPhase=Data1D(ses).LFP.ThetaPhase;
Forward=Data1D(ses).beh.Forward;
SpeedBoolean=Data1D(ses).beh.Speed>10;
forwardRunningSpikes=Forward(SpikeIndices);
RunningSpikes=SpeedBoolean(SpikeIndices);
ThetaPhaseBins=linspace(-pi, pi, 30);
Occupancy=hist(ThetaPhase,ThetaPhaseBins)*Dt;
SpikesBinned=hist(ThetaPhase(SpikeIndices),ThetaPhaseBins);
TuningCurve=SpikesBinned ./ Occupancy; 
figure;plot(ThetaPhaseBins,TuningCurve)
title('Theta Phase Modulation')
xlabel('Theta Phase (radian)')
ylabel('Firing rate (Hz)')

figure; 
subplot(1,2,1)
Occupancy=hist(ThetaPhase(Forward),ThetaPhaseBins)*Dt;
SpikesBinned=hist(ThetaPhase(forwardRunningSpikes),ThetaPhaseBins);
TuningCurveTF=SpikesBinned ./ Occupancy; 
plot(ThetaPhaseBins,TuningCurveTF)
title(' Theta Phase Modulation in forward trial')
xlabel('Theta Phase (radian)')
ylabel('Firing rate (Hz)')
Occupancy=hist(ThetaPhase(~Forward),ThetaPhaseBins)*Dt;
SpikesBinned=hist(ThetaPhase(~forwardRunningSpikes),ThetaPhaseBins);
TuningCurveTB=SpikesBinned ./ Occupancy;
subplot(1,2,2)
plot(ThetaPhaseBins,TuningCurveTB)
title(' Theta Phase Modulation in backward trial')
xlabel('Theta Phase (radian)')
ylabel('Firing rate (Hz)')

% We see correlation between spikes and theta in forward and backward trial
% seperately, But when combined together we dont see any correlation.
%% Q2
SpatialBins=linspace(min(Position),max(Position),26);
Occupancy=hist(Position(Forward),SpatialBins)*Dt;
SpikesBinned=hist(Position(forwardRunningSpikes),SpatialBins);
TuningCurveSF=SpikesBinned ./ Occupancy;

Occupancy=hist(Position(~Forward),SpatialBins)*Dt;
SpikesBinned=hist(Position(~forwardRunningSpikes),SpatialBins);
TuningCurveSB=SpikesBinned ./ Occupancy;

SparsityPositionForward = makeSparsity(TuningCurveSF);
SparsityPositionBackward = makeSparsity(TuningCurveSB);
SparsityThetaForward = makeSparsity(TuningCurveTF);
SparsityThetaBackward = makeSparsity(TuningCurveTB);

%% Q3
ses=1;
ID=1; 
for i = 1:3
    ID = i;
    SpikeTimes=Data2D(ses).UIF(ID).ST;
    TimeVector=Data2D(ses).beh.Time;
    Dt=median(diff(TimeVector))/1e6;
    Position=Data2D(ses).beh.Position;

    figure; 
    x=Position(:,1);
    y=Position(:,2);
    plot(x,y,'k.')
    str = sprintf('Place cell %d', i);
    title(str)

    hold on

    SpikeIndices=nearestpoint(SpikeTimes,TimeVector);
    x=Position(SpikeIndices,1);
    y=Position(SpikeIndices,2);
    plot(x,y,'r*')

    hold off

end
%% Q4
xPositionBins=linspace(min(Position(:,1)),max(Position(:,1)),30);
yPositionBins=linspace(min(Position(:,2)),max(Position(:,2)),30);
Occupancy_2D=histcn(Position,...
    xPositionBins,yPositionBins);
Spikes2D=histcn(Position(SpikeIndices,:),...
    xPositionBins,yPositionBins);
for i = 1:29
    for j = 1:29
        if(Occupancy_2D(i,j) == 0)
            Spikes2D(i,j) = NaN;
        end
    end
end
surf(Spikes2D)
%% Q5
