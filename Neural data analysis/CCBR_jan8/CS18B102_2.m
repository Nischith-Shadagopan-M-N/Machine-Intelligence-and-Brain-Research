%% Personal details
% Name : Nischith
% Roll number : CS18B102
clear all

%% Q1
s1 = sin(0:0.1:pi)*3 + 40;
s2 = sin(0:0.1:pi)*3 + 60;
s3 = sin(0:0.1:pi)*6 + 40;
s4 = sin(0:0.1:pi)*6 + 60;
sparsity1 = makeSparsity(s1);
sparsity2 = makeSparsity(s2);
sparsity3 = makeSparsity(s3);
sparsity4 = makeSparsity(s4);
% When offset is increased, (nansum(amps).^2) increases more than
%(nansum(amps.^2)) and hence sparsity decreases. When scaling factor
%increases, if (nansum(amps).^2) increases by x times then
%(nansum(amps.^2)) increases by x^2 times and hence sparsity increases.

%% Q2

T=5; 
N=100;
Dt=1e-3;
Timepoints=T/Dt; 
TimeVector=Dt:Dt:5;
timep = (3-2)/Dt + 1;
Equispaced_Angles = linspace(0,pi,timep);
FR = zeros(1,Timepoints);
FR = FR+2;
size(8*sin(Equispaced_Angles))
FR(1,2000:3000) = FR(1,2000:3000) + 8*sin(Equispaced_Angles);
figure;
plot(FR);
Lambda = FR * Dt;
Lambda_AllTrials=repmat(Lambda,100,1);
Rand=rand([Timepoints,N]); 
Spikes=zeros([Timepoints,N]);
Spikes(Rand<transpose(Lambda_AllTrials))=1;
TuningCurve=sum(Spikes')/N;
NewTimeVector=TimeVector(100:100:end);
for i=1:Timepoints/100
NewTuningCurve(i)=sum(TuningCurve((100*(i-1)+1):100*i));
end
Sparsity=makeSparsity(NewTuningCurve);
fprintf(['Tuned spike matrix sparsity= ' num2str(Sparsity) '\n'])
shuffledSparsities = zeros(100, 1);
for i=1:100
    ShuffledSpikeMatrix=ShuffleTrials(Spikes);
    TuningCurve_shuffled=sum(ShuffledSpikeMatrix');
    NewTimeVector=TimeVector(100:100:end);
    for i=1:Timepoints/100
    NewTuningCurve_shuffled(i)=sum(TuningCurve_shuffled((100*(i-1)+1):100*i));
    end
    shuffledSparsities(i)=makeSparsity(NewTuningCurve_shuffled);
end
Sparsities = [shuffledSparsities;Sparsity];
Sparsities(50)
sum(Sparsities(1:40)/40)
Sparsities(101)
Ze = zscore(Sparsities);
Z = Ze(101);
figure;
plot(Ze);
